const mongoose = require('mongoose');

const taskSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
  },
  isCompleted: {
    type: Boolean,
    default: false,
  },
  dueDate: {
    type: Date,
    required: false,
  },
  timestamp: {
    type: Date,
    default: Date.now,
  },
});

const Task = mongoose.model('Task', taskSchema, 'tasks');

module.exports = Task;