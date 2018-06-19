//
//  APIs.swift
//  BAKCO VanKhang
//
//  Created by Kiet on 4/11/18.
//  Copyright © 2018 Pham An. All rights reserved.
//

import Foundation

var _deviceToken = String()

struct HeaderApi {
    static let dev = "http://202.78.227.176:8009"  /// Để Dev
    static let test = "http://apiv2.vkhealth.vn"   /// Để test
    static let deploy = "http://api.vkhealth.vn"   /// Đề upload
}

public let ApiDomain = HeaderApi.deploy

struct API {
    static let sosEmergency = ApiDomain + "/api/SOSCall/CallSOS"
    static let getHealthCareScheduler = ApiDomain + "/api/BkHealthCareScheduler/GetByHospitalHealthCareId"
    static let createExaminationNote = ApiDomain + "/api/BkMedicalExaminationNote/CreateForMember"
    static let createExaminationNoteByDoctor = ApiDomain + "/api/BkMedicalExaminationNote/CreateWithDoctor"
    static let getFirstAppointment = ApiDomain + "/api/BkMedicalExaminationNote/Create"
    static let getSchedule = ApiDomain + "/api/BkCustomer/GetSchedulerCustomer"
    static let getDetailScheduler = ApiDomain + "/api/BkDoctor/GetWorkDetail"
    static let register = ApiDomain + "/api/Account/CustomerRegister"
    static let getToken = ApiDomain + "/Token"
    static let getUserId  = ApiDomain + "/api/Account/UserInfo"
    static let getUserById = ApiDomain + "/api/BkCustomer/GetById/"
    static let updateInform = ApiDomain + "/api/BkCustomer/Update"
    static let getDoctor = ApiDomain + "/api/BkHospital/GetDoctorByHospitalId"
    static let getSchedulerByDoctor = ApiDomain + "/api/BkHealthCareScheduler/GetByDoctor"
    static let getSchedulerCustomer = ApiDomain + "/api/BkCustomer/GetSchedulerCustomer" 
    static let signalR = ApiDomain + "/signalr/hubs"
    static let getHealthCareByHospital = ApiDomain + "/api/BkHealthCare/GetByHospitalId"
    static let getHospital = ApiDomain + "/api/BkHospital/Get"
    static let updateHI = ApiDomain + "/api/BkCustomer/UpdateHealthInsurance"
    static let getHI = ApiDomain + "/api/BkCustomer/GetHealthInsurance"
    static let getPaintents = ApiDomain + "/api/BkCustomer/GetProfiles"
    static let createCustomer = ApiDomain + "/api/BkCustomer/Create"
    static let addProfiles = ApiDomain + "/api/BkCustomer/AddProfiles"
    
    struct TeleHealth {
        static let getHospitals = ApiDomain + "/api/BkHospital/GetByUnitType"
        static let getSchedule = ApiDomain + "/api/TelehealthSchedule/GetScheduleByDoctor"
    }
    
    struct FamilyDoctor {
        static let serviceDetail = ApiDomain + "/api/BkFamilyDoctor/GetServiceDetails"
        static let checkContract = ApiDomain + "/api/BkFamilyDoctor/CheckContractVKSOS"
        static let favoriteDoctorList = ApiDomain + "/api/BkFamilyDoctor/GetFavoriteDoctorList"
        static let doctorListByService = ApiDomain + "/api/BkFamilyDoctor/GetDoctorListByService"
        static let callService = ApiDomain + "/api/BkFamilyDoctor/CallFamilyDoctorService"
        static let removeDoctor = ApiDomain + "/api/BkFamilyDoctor/RemoveDoctorFromFavorite"
        static let addDoctor = ApiDomain + "/api/BkFamilyDoctor/AddDoctorToFavorite"
        static let serviceStatus = ApiDomain + "/api/BkFamilyDoctor/CheckFamilyDoctorServiceStatus"
    }
    
    struct Location {
        static let getCities = ApiDomain + "/api/Location/GetCities"
        static let getDistricts = ApiDomain + "/api/Location/GetDistricts"
        static let getWards = ApiDomain + "/api/Location/GetWards"
    }
}

struct Link {
    static let _TrueconfLink = "http://vkhealth.vn/#/tcs"
    static let _MedicalTvLink = "http://yttv.vn"
}







