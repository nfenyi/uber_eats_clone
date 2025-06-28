// enum Result { success, failure, aborted }

enum PhoneNumberVerificationStatus { verified, pendingOTP, failed }

enum AuthState {
  gettingStarted,
  registeringWithEmail,
  registeringWithPhoneNumber,
  addedEmailToPhoneNumber,
  addressDetailsSaved,
  authenticated,
  unAuthenticated,
  federatedRegistration,
}
