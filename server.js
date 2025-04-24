const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 5000;

// ใช้ body-parser เพื่ออ่านข้อมูลจาก body ของ request
app.use(express.json());
app.use(cors());

// เชื่อมต่อ MongoDB (โดยใช้ connection string จาก .env)
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => {
  console.log("Connected to MongoDB Atlas successfully!");
}).catch((err) => {
  console.error("Error connecting to MongoDB Atlas: ", err);
});

// สร้าง schema และ model สำหรับ Task
const taskSchema = new mongoose.Schema({
  title: { type: String, required: true },
  isCompleted: { type: Boolean, default: false },
  dueDate: { type: Date, required: false },
  timestamp: { type: Date, default: Date.now }
});

// สร้าง model โดยให้ชื่อ collection เป็น 'tasks'
const Task = mongoose.model('Task', taskSchema, 'tasks');

// 1. ดึงข้อมูลทั้งหมดจาก MongoDB
app.get('/api/tasks', async (req, res) => {
  try {
    const tasks = await Task.find();  // ดึงข้อมูลทั้งหมดจาก collection 'tasks'
    res.json(tasks);  // ส่งข้อมูลกลับในรูปแบบ JSON
  } catch (err) {
    console.error("Error fetching tasks: ", err);
    res.status(500).send("Error fetching tasks");
  }
});

// 2. อัปเดตข้อมูล task
app.put('/api/tasks/:id', async (req, res) => {
  try {
    const task = await Task.findById(req.params.id);  // หา task ที่ต้องการอัปเดต
    if (!task) return res.status(404).json({ message: 'Task not found' });

    // อัปเดตข้อมูล
    task.title = req.body.title || task.title;
    task.isCompleted = req.body.isCompleted !== undefined ? req.body.isCompleted : task.isCompleted;
    task.dueDate = req.body.dueDate || task.dueDate;

    await task.save(); // บันทึกข้อมูลใหม่ลงฐานข้อมูล
    res.status(200).json(task); // ส่งกลับข้อมูลที่อัปเดตแล้ว
  } catch (err) {
    console.error("Error updating task: ", err);
    res.status(500).send("Error updating task");
  }
});

// 3. ลบ task
app.delete('/api/tasks/:id', async (req, res) => {
  try {
    const task = await Task.findById(req.params.id);  // หา task ที่จะลบ
    if (!task) return res.status(404).json({ message: 'Task not found' });

    await task.remove();  // ลบ task ออกจากฐานข้อมูล
    res.status(200).json({ message: 'Task deleted' });  // ส่งข้อความแจ้งการลบ
  } catch (err) {
    console.error("Error deleting task: ", err);
    res.status(500).send("Error deleting task");
  }
});

// 4. เพิ่ม Task ใหม่
app.post('/api/tasks', async (req, res) => {
  const { title, dueDate } = req.body;

  try {
    const newTask = new Task({
      title,
      dueDate,
    });

    await newTask.save();
    res.status(201).json(newTask);
  } catch (err) {
    console.error("Error creating task:", err);
    res.status(400).json({ message: err.message });
  }
});



// ฟังคำขอจาก port ที่กำหนด
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
