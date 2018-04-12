//
//  APIs.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 4/11/18.
//  Copyright © 2018 Pham An. All rights reserved.
//

import Foundation


let _TrueconfLink = "http://vkhealth.vn/#/tcs"
let _SOSEmergencyApi = "http://api.vkhs.vn/api/SOSCall/CallSOS"
let _GetHealthCareSchedulerApi = "http://api.vkhs.vn/api/BkHealthCareScheduler/GetByHospitalHealthCareId"
let _GetMatchApi = "http://api.vkhs.vn/api/BkMedicalExaminationNote/CreateForMember"
let _GetFirstAppointmentApi = "http://api.vkhs.vn/api/BkMedicalExaminationNote/Create"
let _GetScheduleApi = "http://api.vkhs.vn/api/BkCustomer/GetSchedulerCustomer"
let _GetDetailSchedulerApi = "http://api.vkhs.vn/api/BkDoctor/GetWorkDetail"
let _RegisterURL = "http://api/Account/CustomerRegister"
let _GetTokenApi = "http://api.vkhs.vn/Token"
let _GetUserIdApi  = "http://api.vkhs.vn/api/Account/UserInfo"

var _deviceToken = String()

/// Location
let _GetCitiesApi = "http://api.vkhs.vn/api/Location/GetCities"
let _GetDistrictsApi = "http://api.vkhs.vn/api/Location/GetDistricts"
let _GetWardsApi = "http://api.vkhs.vn/api/Location/GetWards"


/// UPdate HI
let _UpdateHIApi = "http://api.vkhs.vn/api/BkCustomer/UpdateHealthInsurance"
let _GetHIApi = "http://api.vkhs.vn/api/BkCustomer/GetHealthInsurance"

struct FamilyDocrorApi {
    
    static let serviceDetail = "http://api.vkhealth.vn/api/BkFamilyDoctor/GetServiceDetails"
    static let checkContract = "http://api.vkhs.vn/api/BkFamilyDoctor/CheckContractVKSOS"
    static let favoriteDoctorList = "http://api.vkhealth.vn/api/BkFamilyDoctor/GetFavoriteDoctorList"
    static let doctorListByService = "http://api.vkhealth.vn/api/BkFamilyDoctor/GetDoctorListByService"
    static let service = "http://api.vkhealth.vn/api/BkFamilyDoctor/CallFamilyDoctorService"
    static let removeDoctor = "http://api.vkhealth.vn/api/BkFamilyDoctor/RemoveDoctorToFavorite"
    static let addDoctor = "http://api.vkhealth.vn/api/BkFamilyDoctor/AddDoctorToFavorite"
    static let serviceStatus = "http://api.vkhs.vn/api/BkFamilyDoctor/CheckFamilyDoctorServiceStatus"
    
}



