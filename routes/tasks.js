const express = require('express');
const Task = require('../models/task');
const router = express.Router();

// Create a new task
router.post('/', async (req, res) => {
  const { title, dueDate } = req.body;
  try {
    const newTask = new Task({ title, dueDate });
    await newTask.save();
    res.status(201).json(newTask);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Get all tasks
router.get('/', async (req, res) => {
  try {
    const tasks = await Task.find();  // ดึงข้อมูลทั้งหมดจาก collection 'tasks'
    res.status(200).json(tasks);  // ส่งข้อมูลกลับในรูปแบบ JSON
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Update a task
router.put('/:id', async (req, res) => {
  try {
    const task = await Task.findById(req.params.id);
    if (!task) return res.status(404).json({ message: 'Task not found' });

    task.title = req.body.title || task.title;
    task.isCompleted = req.body.isCompleted !== undefined ? req.body.isCompleted : task.isCompleted;
    task.dueDate = req.body.dueDate || task.dueDate;
    
    await task.save();
    res.status(200).json(task);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Delete a task
router.delete('/:id', async (req, res) => {
  try {
    const task = await Task.findById(req.params.id);
    if (!task) return res.status(404).json({ message: 'Task not found' });

    await task.remove();
    res.status(200).json({ message: 'Task deleted' });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

module.exports = router;
