// index.js (Firebase Cloud Function - v2 Syntax)
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const {CloudTasksClient} = require("@google-cloud/tasks");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {onDocumentUpdated} = require("firebase-functions/v2/firestore");
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
  host: "smtp.gmail.com",
  port: 465,
  secure: true,
  auth: {
    user: "fenyi1652@gmail.com",
    pass: "hfiz tack hsui tgfz",
  },
});

exports.scheduleEmailTask = onDocumentCreated("gift cards ankasa/{documentId}", async (event) => {
  logger.info("scheduleEmailTask triggered", {structuredData: true});
  // const giftCardData = event.data?.data();
  const giftCardData = event.data && event.data.data ? event.data.data() : undefined;
  // const context = event.context;

  if (!giftCardData) {
    logger.warn("No data found in the created document.");
    return;
  }

  // since freeze converts dates to string in toJson method
  const deliveryDateString = giftCardData.deliverySchedule;

  if (deliveryDateString) {
    const deliveryDateObj = new Date(deliveryDateString); // Parse the string
    const now = new Date();
    const delay = deliveryDateObj.getTime() - now.getTime();


    if (delay > 0) {
      const project = process.env.GCLOUD_PROJECT;
      const queue = "email-queue";
      const location = "us-central1";
      const url = `https://${location}-${project}.cloudfunctions.net/sendEmail`;
      const payload = Buffer.from(JSON.stringify({giftCardId: event.data.id})).toString("base64");

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
        const [response] = tasksClient.createTask({parent: parent, task: task});
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

exports.onDocumentUpdatedScheduleEmailTask = onDocumentUpdated(
    "gift cards ankasa/{documentId}",
    async (event) => {
      logger.info("onDocumentUpdatedScheduleEmailTask triggered", {
        structuredData: true,
      });

      const beforeData = event.data ? event.data.before.data() : undefined;
      const afterData = event.data ? event.data.after.data() : undefined;
      const documentId = event.params.documentId;

      if (!afterData) {
        logger.warn("No data found in the updated document.");
        return;
      }

      // Check if the deliverySchedule field has been added or changed
      if (
        afterData.deliverySchedule &&
        (beforeData ? beforeData.deliverySchedule : undefined !== afterData.deliverySchedule)
      ) {
        const deliveryDateString = afterData.deliverySchedule;

        if (deliveryDateString) {
          const deliveryDateObj = new Date(deliveryDateString); // Parse the string
          const now = new Date();
          const delay = deliveryDateObj.getTime() - now.getTime();

          if (delay > 0) {
            const project = process.env.GCLOUD_PROJECT;
            const queue = "email-queue";
            const location = "us-central1";
            const url = `https://${location}-${project}.cloudfunctions.net/sendEmail`;
            const payload = Buffer.from(
                JSON.stringify({giftCardId: documentId}),
            ).toString("base64");

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
              const [response] = tasksClient.createTask({
                parent: parent,
                task: task,
              });
              logger.info(`Task scheduled for ${deliveryDateObj}`, {
                taskId: response.name,
              });
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
      } else {
        logger.info(
            "deliverySchedule field not updated or does not exist. No email scheduled.",
        );
      }
    },
);

exports.sendEmail = onRequest(async (req, res) => {
  logger.info("sendEmail called", {structuredData: true});
  try {
    const {giftCardId} = req.body;

    if (!giftCardId || typeof giftCardId !== "string" || giftCardId.trim() === "") {
      logger.error(`Invalid or missing giftCardId in request body: ${JSON.stringify(req.body)}`);
      return res.status(400).send("Invalid gift card ID in request.");
    }
    const doc = await db.collection("gift cards ankasa").doc(giftCardId).get();
    if (!doc.exists) {
      logger.error(`Gift card document with ID ${giftCardId} not found.`);
      return res.status(404).send("Gift card not found.");
    }
    const giftCardData = doc.data();
    const mailOptions = {
      from: "fenyi1652@gmail.com",
      to: giftCardData.recipientAddress,
      subject: `You Have Received a Gift from ${giftCardData.senderName}`,
      text: `Tap the link below to access it\n${giftCardData.dynamicLink}`,
    };

    await transporter.sendMail(mailOptions).then(()=> {
      logger.info("Email sent");
    }).catch((err) => {
      logger.info(err);
    });
    await db.collection("gift cards ankasa").doc(giftCardId).update({sent: true});
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
