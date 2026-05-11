const db = require('../config/db');

const cleanText = (value) => {
  if (value === undefined || value === null) return '';
  return String(value).trim();
};

const normalizeNotificationInput = ({
  title,
  title_ar,
  title_en,
  messageContent,
  messageContent_ar,
  messageContent_en,
}) => {
  const normalizedTitleAr = cleanText(title_ar || title);
  const normalizedTitleEn = cleanText(title_en || title);

  const normalizedMessageAr = cleanText(messageContent_ar || messageContent);
  const normalizedMessageEn = cleanText(messageContent_en || messageContent);

  return {
    title: cleanText(title || normalizedTitleAr || normalizedTitleEn),
    title_ar: normalizedTitleAr,
    title_en: normalizedTitleEn,

    messageContent: cleanText(
      messageContent || normalizedMessageAr || normalizedMessageEn
    ),
    messageContent_ar: normalizedMessageAr,
    messageContent_en: normalizedMessageEn,
  };
};

const insertNotification = async ({
  title,
  title_ar,
  title_en,
  notificationType,
  messageContent,
  messageContent_ar,
  messageContent_en,
  recipientUserID,
  recipientType,
  createdByAdminID,
}) => {
  await db.query(
    `
    INSERT INTO notification (
      title,
      title_ar,
      title_en,
      notificationType,
      timestamp,
      messageContent,
      messageContent_ar,
      messageContent_en,
      recipientUserID,
      recipientType,
      createdByAdminID
    )
    VALUES (?, ?, ?, ?, NOW(), ?, ?, ?, ?, ?, ?)
    `,
    [
      title,
      title_ar,
      title_en,
      notificationType,
      messageContent,
      messageContent_ar,
      messageContent_en,
      recipientUserID,
      recipientType,
      createdByAdminID,
    ]
  );
};

exports.getAccountsTree = async () => {
  const [rows] = await db.query(`
    SELECT 
      p.providerID,
      p.fullName AS providerName,
      p.email AS providerEmail,
      p.phoneNumber AS providerPhone,

      c.campaignID,
      c.campaignName,
      c.campaignNumber,
      c.numberOfPilgrims,
      c.arrivalDetails,

      pg.pilgrimID,
      pg.fullName AS pilgrimName,
      pg.email AS pilgrimEmail,
      pg.phoneNumber AS pilgrimPhone

    FROM provider p

    LEFT JOIN campaign c
      ON c.providerID = p.providerID

    LEFT JOIN pilgrim pg
      ON pg.campaignID = c.campaignID

    ORDER BY
      p.fullName,
      c.campaignName,
      pg.fullName
  `);

  const providersMap = {};

  rows.forEach((row) => {
    if (!providersMap[row.providerID]) {
      providersMap[row.providerID] = {
        providerID: row.providerID,
        providerName: row.providerName,
        providerEmail: row.providerEmail,
        providerPhone: row.providerPhone,
        campaigns: [],
      };
    }

    if (row.campaignID) {
      let campaign = providersMap[row.providerID].campaigns.find(
        (c) => c.campaignID === row.campaignID
      );

      if (!campaign) {
        campaign = {
          campaignID: row.campaignID,
          campaignName: row.campaignName,
          campaignNumber: row.campaignNumber,
          numberOfPilgrims: row.numberOfPilgrims,
          arrivalDetails: row.arrivalDetails,
          pilgrims: [],
        };

        providersMap[row.providerID].campaigns.push(campaign);
      }

      if (row.pilgrimID) {
        campaign.pilgrims.push({
          pilgrimID: row.pilgrimID,
          pilgrimName: row.pilgrimName,
          pilgrimEmail: row.pilgrimEmail,
          pilgrimPhone: row.pilgrimPhone,
        });
      }
    }
  });

  return Object.values(providersMap);
};

exports.getOrdersMonitor = async () => {
  const [rows] = await db.query(`
    SELECT
      c.campaignID,
      c.campaignName,
      c.campaignNumber,

      p.providerID,
      p.fullName AS providerName,
      p.email AS providerEmail,

      o.orderID,
      o.requestDate,
      o.status,

      pg.pilgrimID,
      pg.fullName AS pilgrimName,
      pg.email AS pilgrimEmail,

      m.mealID,
      m.mealName,
      m.mealName_ar,
      m.mealName_en,
      m.mealType,
      m.mealType_ar,
      m.mealType_en,
      m.calories

    FROM campaign c

    LEFT JOIN provider p
      ON p.providerID = c.providerID

    LEFT JOIN pilgrim pg
      ON pg.campaignID = c.campaignID

    LEFT JOIN meal_order o
      ON o.pilgrimID = pg.pilgrimID

    LEFT JOIN meal m
      ON m.mealID = o.mealID

    ORDER BY
      c.campaignName,
      p.fullName,
      o.requestDate DESC
  `);

  const campaignsMap = {};

  rows.forEach((row) => {
    if (!campaignsMap[row.campaignID]) {
      campaignsMap[row.campaignID] = {
        campaignID: row.campaignID,
        campaignName: row.campaignName,
        campaignNumber: row.campaignNumber,

        provider: {
          providerID: row.providerID,
          providerName: row.providerName,
          providerEmail: row.providerEmail,
        },

        orders: [],
      };
    }

    if (row.orderID) {
      campaignsMap[row.campaignID].orders.push({
        orderID: row.orderID,
        requestDate: row.requestDate,
        status: row.status,

        pilgrimID: row.pilgrimID,
        pilgrimName: row.pilgrimName,
        pilgrimEmail: row.pilgrimEmail,

        mealID: row.mealID,

        mealName: row.mealName,
        mealName_ar: row.mealName_ar || row.mealName || '',
        mealName_en: row.mealName_en || row.mealName || '',

        mealType: row.mealType,
        mealType_ar: row.mealType_ar || row.mealType || '',
        mealType_en: row.mealType_en || row.mealType || '',

        calories: row.calories,
      });
    }
  });

  return Object.values(campaignsMap);
};

exports.createNotification = async ({
  title,
  title_ar,
  title_en,
  notificationType,
  messageContent,
  messageContent_ar,
  messageContent_en,
  recipientType,
  recipientUserID,
  createdByAdminID,
}) => {
  const normalized = normalizeNotificationInput({
    title,
    title_ar,
    title_en,
    messageContent,
    messageContent_ar,
    messageContent_en,
  });

  const finalNotificationType = cleanText(notificationType) || 'info';

  // ALL PILGRIMS
  if (recipientType === 'all_pilgrims') {
    const [pilgrims] = await db.query(`SELECT pilgrimID FROM pilgrim`);

    for (const pilgrim of pilgrims) {
      await insertNotification({
        ...normalized,
        notificationType: finalNotificationType,
        recipientUserID: pilgrim.pilgrimID,
        recipientType: 'pilgrim',
        createdByAdminID,
      });
    }

    return {
      message: 'Notification sent to all pilgrims',
    };
  }

  // ALL PROVIDERS
  if (recipientType === 'all_providers') {
    const [providers] = await db.query(`SELECT providerID FROM provider`);

    for (const provider of providers) {
      await insertNotification({
        ...normalized,
        notificationType: finalNotificationType,
        recipientUserID: provider.providerID,
        recipientType: 'provider',
        createdByAdminID,
      });
    }

    return {
      message: 'Notification sent to all providers',
    };
  }

  // SPECIFIC USER
  await insertNotification({
    ...normalized,
    notificationType: finalNotificationType,
    recipientUserID,
    recipientType,
    createdByAdminID,
  });

  return {
    message: 'Notification created successfully',
  };
};

exports.getSentNotifications = async () => {
  const [rows] = await db.query(`
    SELECT
      notificationID,

      title,
      title_ar,
      title_en,

      notificationType,
      timestamp,

      messageContent,
      messageContent_ar,
      messageContent_en,

      recipientUserID,
      recipientType,
      createdByAdminID
    FROM notification
    ORDER BY timestamp DESC
  `);

  return rows.map((row) => {
    const titleAr = row.title_ar || row.title || '';
    const titleEn = row.title_en || row.title || '';

    const messageAr = row.messageContent_ar || row.messageContent || '';
    const messageEn = row.messageContent_en || row.messageContent || '';

    return {
      ...row,

      title: row.title || titleAr || titleEn,
      title_ar: titleAr,
      title_en: titleEn,

      messageContent: row.messageContent || messageAr || messageEn,
      messageContent_ar: messageAr,
      messageContent_en: messageEn,
    };
  });
};

exports.getAdminProfile = async (adminID) => {
  const sql = `
    SELECT adminID, fullName, email, phoneNumber
    FROM admin
    WHERE adminID = ?
  `;

  const [rows] = await db.query(sql, [adminID]);

  return rows[0];
};