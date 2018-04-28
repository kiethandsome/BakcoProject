//
//  APIs.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 4/11/18.
//  Copyright © 2018 Pham An. All rights reserved.
//

import Foundation


let _TrueconfLink = "http://vkhealth.vn/#/tcs"
let _MedicalTvLink = "http://yttv.vn"

let _SOSEmergencyApi = "http://api.vkhealth.vn/api/SOSCall/CallSOS"
let _GetHealthCareSchedulerApi = "http://api.vkhealth.vn/api/BkHealthCareScheduler/GetByHospitalHealthCareId"
let _GetMatchApi = "http://api.vkhealth.vn/api/BkMedicalExaminationNote/CreateForMember"
let _GetFirstAppointmentApi = "http://api.vkhealth.vn/api/BkMedicalExaminationNote/Create"
let _GetScheduleApi = "http://api.vkhealth.vn/api/BkCustomer/GetSchedulerCustomer"
let _GetDetailSchedulerApi = "http://api.vkhealth.vn/api/BkDoctor/GetWorkDetail"
let _RegisterURL = "http://api.vkhealth.vn/api/Account/CustomerRegister"
let _GetTokenApi = "http://api.vkhealth.vn/Token"
let _GetUserIdApi  = "http://api.vkhealth.vn/api/Account/UserInfo"
let _UpdateInformApi = "http://api.vkhealth.vn/api/BkCustomer/Update"

var _deviceToken = String()

/// Location
let _GetCitiesApi = "http://api.vkhealth.vn/api/Location/GetCities"
let _GetDistrictsApi = "http://api.vkhealth.vn/api/Location/GetDistricts"
let _GetWardsApi = "http://api.vkhealth.vn/api/Location/GetWards"


/// UPdate HI
let _UpdateHIApi = "http://api.vkhealth.vn/api/BkCustomer/UpdateHealthInsurance"
let _GetHIApi = "http://api.vkhealth.vn/api/BkCustomer/GetHealthInsurance"

struct FamilyDocrorApi {
    
    static let serviceDetail = "http://api.vkhealth.vn/api/BkFamilyDoctor/GetServiceDetails"
    static let checkContract = "http://api.vkhealth.vn/api/BkFamilyDoctor/CheckContractVKSOS"
    static let favoriteDoctorList = "http://api.vkhealth.vn/api/BkFamilyDoctor/GetFavoriteDoctorList"
    static let doctorListByService = "http://api.vkhealth.vn/api/BkFamilyDoctor/GetDoctorListByService"
    static let callService = "http://api.vkhealth.vn/api/BkFamilyDoctor/CallFamilyDoctorService"
    static let removeDoctor = "http://api.vkhealth.vn/api/BkFamilyDoctor/RemoveDoctorFromFavorite"
    static let addDoctor = "http://api.vkhealth.vn/api/BkFamilyDoctor/AddDoctorToFavorite"
    static let serviceStatus = "http://api.vkhealth.vn/api/BkFamilyDoctor/CheckFamilyDoctorServiceStatus"
    
}



