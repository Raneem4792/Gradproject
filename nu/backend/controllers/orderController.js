const db = require('../config/db');
const orderService = require('../services/OrderService');
const {
  createAdminNotification,
} = require('../services/adminService');

class OrderController {
  async createOrder(req, res) {
    try {
      const { mealID, pilgrimID } = req.body;

      if (!mealID || !pilgrimID) {
        return res.status(400).json({
          message: 'mealID and pilgrimID are required',
        });
      }

      const result = await orderService.createOrder(mealID, pilgrimID);

      await createAdminNotification({
        title: 'New Meal Order',
        title_ar: 'طلب وجبة جديد',
        title_en: 'New Meal Order',

        notificationType: 'meal_order_created',

        messageContent: `New meal order submitted`,
        messageContent_ar: `تم تقديم طلب وجبة جديد`,
        messageContent_en: `A new meal order has been submitted`,
      });

      return res.status(201).json(result);
    } catch (error) {
      console.error('Create order error:', error);
      return res.status(500).json({
        message: 'Failed to create order',
      });
    }
  }

  async getOrdersByPilgrim(req, res) {
    try {
      const { pilgrimID } = req.params;
      const orders = await orderService.getOrdersByPilgrim(pilgrimID);

      return res.status(200).json(orders);
    } catch (error) {
      console.error('Get pilgrim orders error:', error);
      return res.status(500).json({
        message: 'Failed to load orders',
      });
    }
  }

  async getCampaignsByProvider(req, res) {
    try {
      const { providerID } = req.params;
      const campaigns = await orderService.getCampaignsByProvider(providerID);

      return res.status(200).json(campaigns);
    } catch (error) {
      console.error('Get provider campaigns error:', error);
      return res.status(500).json({
        message: 'Failed to load provider campaigns',
      });
    }
  }

  async getOrdersByProvider(req, res) {
    try {
      const { providerID } = req.params;
      const { campaignID } = req.query;

      const orders = await orderService.getOrdersByProvider(
        providerID,
        campaignID ? Number(campaignID) : null
      );

      return res.status(200).json(orders);
    } catch (error) {
      console.error('Get provider orders error:', error);
      return res.status(500).json({
        message: 'Failed to load provider order history',
      });
    }
  }

  async updateOrderStatus(req, res) {
    try {
      const { orderID } = req.params;
      const { status } = req.body;

      if (!status) {
        return res.status(400).json({
          message: 'status is required',
        });
      }

      const normalizedStatus = String(status).trim().toLowerCase();

      await db.query(
        `UPDATE meal_order SET status = ? WHERE orderID = ?`,
        [normalizedStatus, orderID]
      );

      await createAdminNotification({
        title: 'Order Status Updated',
        title_ar: 'تم تحديث حالة الطلب',
        title_en: 'Order Status Updated',

        notificationType: 'meal_order_status_updated',

        messageContent: `Order #${orderID} status changed to ${normalizedStatus}`,
        messageContent_ar: `تم تغيير حالة الطلب رقم ${orderID} إلى ${normalizedStatus}`,
        messageContent_en: `Order #${orderID} status changed to ${normalizedStatus}`,
      });

      const [orderRows] = await db.query(
        `
        SELECT 
          mo.orderID,
          mo.pilgrimID,
          m.mealName,
          m.mealName_ar,
          m.mealName_en
        FROM meal_order mo
        JOIN meal m ON mo.mealID = m.mealID
        WHERE mo.orderID = ?
        `,
        [orderID]
      );

      if (orderRows.length > 0) {
        const order = orderRows[0];

        const mealNameAr =
          order.mealName_ar || order.mealName || order.mealName_en || '';
        const mealNameEn =
          order.mealName_en || order.mealName || order.mealName_ar || '';

        let notificationType = '';
        let messageContent = '';
        let messageContentAr = '';
        let messageContentEn = '';

        if (normalizedStatus === 'accepted') {
          notificationType = 'order_accepted';

          messageContentAr = mealNameAr
            ? `تم قبول طلب وجبة "${mealNameAr}" بنجاح!`
            : 'تم قبول طلب الوجبة الخاص بك بنجاح!';

          messageContentEn = mealNameEn
            ? `Your meal order "${mealNameEn}" has been accepted successfully!`
            : 'Your meal order has been accepted successfully!';

          messageContent = messageContentAr;
        }

        if (normalizedStatus === 'rejected') {
          notificationType = 'order_rejected';

          messageContentAr = mealNameAr
            ? `نعتذر، تم رفض طلب وجبة "${mealNameAr}" من قبل المزود.`
            : 'نعتذر، تم رفض طلب الوجبة الخاص بك من قبل المزود.';

          messageContentEn = mealNameEn
            ? `Sorry, your meal order "${mealNameEn}" has been rejected by the provider.`
            : 'Sorry, your meal order has been rejected by the provider.';

          messageContent = messageContentAr;
        }

        if (messageContent) {
          const titleAr =
            notificationType === 'order_accepted'
              ? 'تم قبول طلب الوجبة'
              : 'تم رفض طلب الوجبة';

          const titleEn =
            notificationType === 'order_accepted'
              ? 'Meal order accepted'
              : 'Meal order rejected';

          await db.query(
            `
    INSERT INTO notification
    (
      title,
      title_ar,
      title_en,
      notificationType,
      messageContent,
      messageContent_ar,
      messageContent_en,
      recipientUserID,
      recipientType
    )
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `,
            [
              titleEn,
              titleAr,
              titleEn,
              notificationType,
              messageContent,
              messageContentAr,
              messageContentEn,
              order.pilgrimID,
              'pilgrim',
            ]
          );
        }
      }

      return res.status(200).json({
        message: 'Order status updated successfully',
      });
    } catch (error) {
      console.error('Update order status error:', error);
      return res.status(500).json({
        message: 'Failed to update order status',
      });
    }
  }
}

module.exports = new OrderController();