//
//  Error.h
//  Raza
//
//  Created by Praveen S on 05/12/13.
//  Copyright (c) 2013 Raza. All rights reserved.
//

#ifndef Raza_Error_h
#define Raza_Error_h

// In general

#define ERROR_NO_NETWORK @"Network Unavailable"
#define ERROR_MIN_PHONE_LENGTH @"Phone no. should be of 10 digits!"
#define ERROR_INVALID_EMAIL @"Email address is incorrect or not in valid format"
#define MESSAGE_DELETE_CONFIRMATION @"Are you sure to delete"

// Empty field validation
#define ERROR_ALL_FIELDS_REQUIRED @"All fields are required"
#define ERROR_EMAIL_REQUIRED @"Please enter email address."
#define ERROR_EMAIL_VALIDATION_REQUIRED @"Please enter valid email address."
#define ERROR_PHONE_VALIDATION_REQUIRED @"Mobile number can not be empty or more than 10 digit"
#define ERROR_PHONE_REQUIRED @"Please enter phone number."

#define ERROR_COUNTRY_FROM_REQUIRED @"Select the country from"
#define ERROR_COUNTRY_TO_REQUIRED @"Country to can not be empty"
#define ERROR_ZIP_CODE_REQUIRED @"Zip code can not be empty"
#define ERROR_PASSWORD_REQUIRED @"Password can not be empty"
#define ERROR_countrycode_REQUIRED @"country code not be empty or more than 1 digit"

#define MEESAGE_SETTING_APPLICATION @"Setting up application"

// Related to access numbers

#define ERROR_NO_ACCESS_NUMBER_ON_NETWORK_FAILURE @"Check network connection while fetching access number"
//#define ERROR_NO_ACCESS_NUMBER_TO_DIAL @"No access number found. Kindly choose from Settings"
#define ERROR_NO_ACCESS_NUMBER_TO_DIAL @"No access number found."
#define ERROR_NO_ACCESS_NUMBER @"There are no access numbers available for your selection please search by state"
#define ERROR_NO_STATE_SELECTED @"Please select Country/State"

#define MESSAGE_GETTING_ACCESS_NUMBERS @"Getting access number(s)"
#define MESSAGE_FETCHING_ACCESS_NUMBERS @"Fetching Access number"


// Related to login
#define ERROR_USERNAME_PWD @"Username or password is wrong!"
#define SUCCESSFULLY_CHANGED_PASSWORD @"Password has been sent to your email"

#define ERROR_NO_USER_PIN @"Pin error"
#define MESSAGE_REGISTERED_SUCCESS @"You have successfully registered"

// Related to reward points

#define ERROR_NO_REWARD_POINTS @"You do not have enough reward points"
#define MESSAGE_FETCHING_REWARD @"Fetching reward points..."

// Related to state

#define ERROR_NO_STATES @"Error while fetching states"

// Related to required fields or missing values

#define ERROR_REQUIRED_PHONE @"Phone number is required"
#define ERROR_REQUIRED_PIN @"User pin is missing"
#define ACCESSPHONE_LENGTH_EXCEED @"Number entered should be of more than 5 digits"

// Related to pinless setup

#define ERROR_NO_PIN @"There are no pinless entries"
#define FETCHING_PINLESS @"Fetching Pinless Setup"
#define DELETE_YOURPIN @"You can't delete login PIN"
#define SUCCESSFULLY_DELETED_PINLESS @"Pinless deleted successfully"
#define SUCCESSFULLY_SETUP_PINLESS @"Pinless setup successfully"
#define PINLESS_ALREADY_EXIST @" Pinless already exist"

// Related to quickeys setup
#define ERROR_NO_QUICKEYS @"There are no quickeys entries"
#define FETCHING_QUICKEYS @"Fetching Quickeys Setup"
#define SUCCESSFULLY_DELETED_QUICKEYS @"Quickeys deleted successfully"
#define SUCCESSFULLY_SETUP_QUICKEYS @"Quickeys setup successful"
#define QUICKEYS_ALREADY_EXIST @" Quickeys already exist"
#define SPEEDDIAL_LENGTH_EXCEED @"Speed Dial should not exceed 3-digits!"

// Related to network
#define NETWORK_AVAILABLE @"Network Available"
#define NETWORK_UNAVAILABLE @"Network Unavailable"
#define RAZASMSRESEND @"Resend verification code successfully!"
#define ERRORVERIFY @"Please enter verification code!"
#define ERROR_OK @"ok"

#define REQUEST_WITHOUT_NETWORK @"No network available"
#define REQUEST_WITHOUT_SIM @"No Sim available"

// Related to view rates

#define MESSAGE_FETCHING_VIEWRATES @"Fetching Country"

// Related to recent calls

#define ERROR_NO_CALL_YET @"No calls made yet"
#define ERROR_NO_MISSED_CALLS @"No missed calls"

// Related to purchase history

#define MESSAGE_FETCHING_PURCHASE_HISTORY @"Fetching purchase history..."

#endif

// Related to call details

#define MESSAGE_FETCHING_CALL_HISTORY @"Fetching call history..."

// Related to billing info
#define MESSAGE_FETCHING_BILLING_INFO @"Fetching billing info..."

/******   Message ****/

// Releated to recharge

#define SUCCESSFULLY_RECHARGE @"Recharge Successful"
#define MESSAGE_RECHARGE_INPROGRESS @"Recharge in progress"
#define ACCEPT_TERMS_CONDITION @"You must accept the Terms & Conditions"
#define RAZALOGGEDOUT @"Sign out Successful"
#define RAZAnocoonect @"Can't signout,either issue with connection or call is running!"
#define RAZAnouser @"No user!"
#define RAZAPUSHCALLER @"*9999"


