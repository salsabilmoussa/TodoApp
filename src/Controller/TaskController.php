<?php

namespace App\Controller;

use App\Document\Task;
use Doctrine\ODM\MongoDB\DocumentManager;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;


#[Route('task')]
class TaskController extends AbstractController
{

    private $documentManager;

    public function __construct(DocumentManager $documentManager)
    {
        $this->documentManager = $documentManager;
    }

    #[Route('/tasks', name: 'app_task')]
    public function index(DocumentManager $documentManager): JsonResponse
    {
        $tasks = $documentManager->getRepository(Task::class)->findAll();

        $tasksArray = [];
        foreach ($tasks as $task) {
            $tasksArray[] = [
                'id' => $task->getId(),
                'title' => $task->getTitle(),
                'description' => $task->getDescription(),
                'isCompleted' => $task->getIsCompleted(),
            ];
        }

        return $this->json($tasksArray);
    }


    #[Route(path: '/new', name: 'task_new', methods: ['POST'])]
    public function new(Request $request): JsonResponse
    {
        $data = json_decode($request->getContent(), true);
        $task = new Task();
        $task->setTitle($data['title']);
        $task->setDescription($data['description']);
        $task->setIsCompleted(false);
        $this->documentManager->persist($task);
        $this->documentManager->flush();

        return $this->json(['message' => 'Nouvelle tache ajoutée'], Response::HTTP_CREATED);
    }

    #[Route(path: '/update/{id}', name: 'task_update', methods: ['PUT'])]
    public function update(string $id, DocumentManager $documentManager, Request $request): JsonResponse
    {
        $data = json_decode($request->getContent(), true);
        $task = $documentManager->getRepository(Task::class)->find($id);
        $task->setTitle($data['title']);
        $task->setDescription($data['description']);
        $this->documentManager->persist($task);
        $this->documentManager->flush();

        return $this->json(['message' => 'Tache modifiée'], Response::HTTP_OK);
    }

    #[Route(path: '/update_status/{id}', name: 'update_status', methods: ['PUT'])]
    public function updateStatus(string $id, DocumentManager $documentManager, Request $request): JsonResponse
    {
        $data = json_decode($request->getContent(), true);
        $task = $documentManager->getRepository(Task::class)->find($id);
        $task->setIsCompleted($data['isCompleted']);
        $this->documentManager->persist($task);
        $this->documentManager->flush();

        return $this->json(['message' => 'Tache modifiée'], Response::HTTP_OK);
    }

    #[Route('/update_order', name: 'update_order', methods: ['POST'])]
    public function updateOrder(Request $request): JsonResponse
    {
        $tasks = $this->documentManager->getRepository(Task::class)->findAll();
        foreach ($tasks as $task) {
            $this->documentManager->remove($task);
        }
        $this->documentManager->flush();

        $data = json_decode($request->getContent(), true);
        foreach ($data as $taskData) {
            $task = new Task();
            $task->setTitle($taskData['title']);
            $task->setDescription($taskData['description']);
            $task->setIsCompleted($taskData['isCompleted']);
            $this->documentManager->persist($task);
        }
        $this->documentManager->flush();

        return $this->json(['message' => 'Reorder successful'], Response::HTTP_OK);
    }

    #[Route(path: '/delete/{id}', name: 'task_delete', methods: ['DELETE'])]
    public function delete(string $id, DocumentManager $documentManager): JsonResponse
    {
        $task = $documentManager->getRepository(Task::class)->find($id);
        if (!$task)
            return $this->json(['message' => 'Tache non trouvée'], Response::HTTP_NOT_FOUND);

        $documentManager->remove($task);
        $documentManager->flush();
        return $this->json(['message' => 'Tache supprimée'], Response::HTTP_OK);
    }
}
