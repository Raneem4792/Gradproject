const express = require('express');
const router = express.Router();

const {
  getPilgrimHomeData,
  getPilgrimProfile,
  updatePilgrimProfile,
} = require('../controllers/pilgrimController');

// 🔹 Home
router.get('/home/:pilgrimID', getPilgrimHomeData);

// 🔹 Profile
router.get('/:pilgrimID', getPilgrimProfile);

// 🔹 Update Profile
router.post('/update', updatePilgrimProfile);

module.exports = router;