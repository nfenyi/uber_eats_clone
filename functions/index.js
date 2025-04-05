// index.js (Firebase Cloud Function - v2 Syntax)
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const {CloudTasksClient} = require("@google-cloud/tasks");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {onRequest} = require("firebase-functions/v2/https");
const {setGlobalOptions} = require("firebase-functions/v2");
const nodemailer = require("nodemailer");
const logger = require("firebase-functions/logger");

initializeApp();
const db = getFirestore();
const tasksClient = new CloudTasksClient();

// Set global options for all functions (optional, but good practice for region)
setGlobalOptions({
  region: "us-central1",
});

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "fenyi1652@gmail.com",
    pass: "wrongcake#18",
  },
});

exports.scheduleEmailTask = onDocumentCreated("/gift cards ankasa", async (event) => {
  logger.info("scheduleEmailTask triggered", {structuredData: true});
  // const giftCardData = event.data?.data();
  const giftCardData = event.data && event.data.data ? event.data.data() : undefined;
  // const context = event.context;

  if (!giftCardData) {
    logger.warn("No data found in the created document.");
    return;
  }

  const deliveryDate = giftCardData.deliverySchedule;

  if (deliveryDate) {
    const deliveryDateObj = deliveryDate.toDate();
    const now = new Date();
    const delay = deliveryDateObj.getTime() - now.getTime();

    if (delay > 0) {
      const project = process.env.GCLOUD_PROJECT;
      const queue = "email-queue";
      const location = "us-central1";
      const url = `https://${location}-${project}.cloudfunctions.net/sendEmailNow`;
      const payload = Buffer.from(JSON.stringify({emailId: event.data.id})).toString("base64");

      const task = {
        httpRequest: {
          httpMethod: "POST",
          url,
          body: payload,
          headers: {
            "Content-Type": "application/json",
          },
        },
        scheduleTime: {
          seconds: deliveryDateObj.getTime() / 1000,
        },
      };

      const parent = tasksClient.queuePath(project, location, queue);
      try {
        const [response] = await tasksClient.createTask({parent: parent, task: task});
        logger.info(`Task scheduled for ${deliveryDateObj}`, {taskId: response.name});
        return response; // Return the promise for proper lifecycle management
      } catch (error) {
        logger.error("Error creating Cloud Task:", error);
        return;
      }
    } else {
      logger.info("Delivery date is in the past.");
    }
  } else {
    logger.info("Delivery date is null. Email will not be scheduled.");
  }
});

exports.sendEmailNow = onRequest(async (req, res) => {
  logger.info("sendEmailNow called", {structuredData: true});
  try {
    // const message = req.body?.message;
    const message = req.body && req.body.message;
    if (!message || !message.data) {
      logger.error("Invalid request body for sendEmailNow");
      return res.status(400).send("Invalid request body.");
    }
    const data = JSON.parse(Buffer.from(message.data, "base64").toString());
    const giftCardId = data.emailId;

    const doc = await db.collection("gift cards ankasa").doc(giftCardId).get();
    if (!doc.exists) {
      logger.error(`Email document with ID ${giftCardId} not found.`);
      return res.status(404).send("Gift card not found.");
    }
    const giftCardData = doc.data();

    const mailOptions = {
      from: "fenyi1652@gmail.com",
      to: giftCardData.recipientAddress,
      subject: `You Have Received a Gift from ${giftCardData.senderName}`,
      text: `Tap the link below to access it\n${giftCardData.dynamicLink}`,
    };

    await transporter.sendMail(mailOptions);
    await db.collection("scheduledEmails").doc(giftCardId).update({sent: true});
    logger.info(
        `Email sent successfully to ${giftCardData.recipientAddress} ` +
        `for gift card ${giftCardId}`,
    );
    res.send("Email sent!");
  } catch (error) {
    logger.error("Error sending email:", error);
    res.status(500).send("Error sending email.");
  }
});
