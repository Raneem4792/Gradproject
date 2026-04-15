const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const mealController = require('../controllers/mealController');

const uploadDir = path.join(__dirname, '../uploads/meals');

if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const uniqueName =
      Date.now() + '-' + Math.round(Math.random() * 1e9) + path.extname(file.originalname);
    cb(null, uniqueName);
  },
});

const fileFilter = (req, file, cb) => {
  const allowedMimeTypes = [
    'image/jpeg',
    'image/png',
    'image/jpg',
    'image/webp',
    'application/octet-stream',
  ];

  const allowedExtensions = ['.jpg', '.jpeg', '.png', '.webp'];

  const ext = path.extname(file.originalname).toLowerCase();
  const mimeOk = allowedMimeTypes.includes(file.mimetype);
  const extOk = allowedExtensions.includes(ext);

  console.log('Uploaded file info:');
  console.log('Original name:', file.originalname);
  console.log('Mime type:', file.mimetype);
  console.log('Extension:', ext);

  if (mimeOk || extOk) {
    cb(null, true);
  } else {
    cb(new Error('Only image files are allowed'));
  }
};

const upload = multer({
  storage,
  fileFilter,
});

router.get('/', (req, res) => mealController.getMeals(req, res));

router.post(
  '/add',
  (req, res, next) => {
    upload.single('image')(req, res, function (err) {
      if (err) {
        console.error('Upload error in add:', err);
        return res.status(400).json({
          message: err.message || 'Image upload failed',
        });
      }
      next();
    });
  },
  (req, res) => mealController.addMeal(req, res)
);

router.put(
  '/update/:id',
  (req, res, next) => {
    upload.single('image')(req, res, function (err) {
      if (err) {
        console.error('Upload error in update:', err);
        return res.status(400).json({
          message: err.message || 'Image upload failed',
        });
      }
      next();
    });
  },
  (req, res) => mealController.updateMeal(req, res)
);

router.delete('/delete/:id', (req, res) => mealController.deleteMeal(req, res));

module.exports = router;