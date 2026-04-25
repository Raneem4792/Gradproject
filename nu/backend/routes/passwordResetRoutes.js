const express = require('express');
const router = express.Router();

const {
  sendResetCode,
  resetPassword
} = require('../controllers/passwordResetController');

router.post('/send-code', sendResetCode);
router.post('/reset-password', resetPassword);

module.exports = router;