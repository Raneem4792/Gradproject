const express = require('express');
const router = express.Router();
const aiChatController = require('../controllers/aiChatController');

router.post('/ai-chat', aiChatController.sendMessage);

module.exports = router;