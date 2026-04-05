const express = require('express');
const router = express.Router();
const healthController = require('../controllers/healthController');

router.get('/:pilgrimID', healthController.getProfile);
router.post('/', healthController.saveProfile);

module.exports = router;