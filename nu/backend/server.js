require('dotenv').config();

const express = require('express');
const cors = require('cors');
const mealRoutes = require('./routes/mealRoutes');
const orderRoutes = require('./routes/orderRoutes');
const authRoutes = require('./routes/authRoutes');
const pilgrimRoutes = require('./routes/pilgrimRoutes');
const rateRoutes = require('./routes/rateRoutes');
const healthRoutes = require('./routes/healthRoutes');
const providerRoutes = require('./routes/providerRoutes');
const campaignRoutes = require('./routes/campaignRoutes');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use('/api/meals', mealRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/pilgrims', pilgrimRoutes);
app.use('/api/rates', rateRoutes);
app.use('/api/health', healthRoutes);
app.use('/api/providers', providerRoutes);
app.use('/api/campaigns', campaignRoutes);

// استدعاء الداتابيس
const db = require('./config/db');

// Route رئيسي
app.get('/', (req, res) => {
  res.send('NUSUQ Backend is running');
});

// اختبار الاتصال بالداتابيس
app.get('/test-db', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT 1');
    res.json({
      message: 'Database connected successfully',
      result: rows
    });
  } catch (error) {
    res.status(500).json({
      message: 'Database connection failed',
      error: error.message
    });
  }
});

// تشغيل السيرفر
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});