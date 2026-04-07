const express = require('express');
const router = express.Router();
const mealController = require('../controllers/mealController');

// 1. جلب كل الوجبات (موجود عندكِ مسبقاً)
router.get('/', (req, res) => mealController.getMeals(req, res));

// 2. إضافة وجبة جديدة (F-3.1 / AC9.1)
// يتم استدعاؤها بطلب POST من فلاتر
router.post('/add', (req, res) => mealController.addMeal(req, res));

// 3. تعديل وجبة موجودة (F-3.2 / AC3.2.1)
// نمرر الـ id الخاص بالوجبة في الرابط
router.put('/update/:id', (req, res) => mealController.updateMeal(req, res));

// 4. حذف وجبة (F-3.3 / AC3.3.1)
// نمرر الـ id الخاص بالوجبة المراد حذفها
router.delete('/delete/:id', (req, res) => mealController.deleteMeal(req, res));

module.exports = router;