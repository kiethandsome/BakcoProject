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
    static let dev = "http://202.78.227.176:8009/api/"  /// Để Dev
    static let test = "http://apiv2.vkhealth.vn/api/"   /// Để test
    static let deploy = "http://api.vkhealth.vn/api/"   /// Đề upload
}

public let ApiDomain = HeaderApi.test /// Constant header

struct API {
    static let sosEmergency = ApiDomain + "SOSCall/CallSOS"
    static let getHealthCareScheduler = ApiDomain + "BkHealthCareScheduler/GetByHospitalHealthCareId"
    static let createExaminationNote = ApiDomain + "BkMedicalExaminationNote/CreateForMember"
    static let createExaminationNoteByDoctor = ApiDomain + "BkMedicalExaminationNote/CreateWithDoctor"
    static let getFirstAppointment = ApiDomain + "BkMedicalExaminationNote/Create"
    static let getSchedule = ApiDomain + "BkCustomer/GetSchedulerCustomer"
    static let getDetailScheduler = ApiDomain + "BkDoctor/GetWorkDetail"
    static let register = ApiDomain + "Account/CustomerRegister"
    static let getToken = ApiDomain + "Token"
    static let getUserId  = ApiDomain + "Account/UserInfo"
    static let getUserById = ApiDomain + "BkCustomer/GetById/"
    static let updateInform = ApiDomain + "BkCustomer/Update"
    static let getDoctor = ApiDomain + "BkHospital/GetDoctorByHospitalId"
    static let getSchedulerByDoctor = ApiDomain + "BkHealthCareScheduler/GetByDoctor"
    static let getSchedulerCustomer = ApiDomain + "BkCustomer/GetSchedulerCustomer"
    static let signalR = "http://api.vkhealth.vn/signalr/hubs"
    static let getHealthCareByHospital = ApiDomain + "BkHealthCare/GetByHospitalId"
    static let getHospital = ApiDomain + "BkHospital/Get"
    static let updateHI = ApiDomain + "BkCustomer/UpdateHealthInsurance"
    static let getHI = ApiDomain + "BkCustomer/GetHealthInsurance"
    
    struct FamilyDoctor {
        static let serviceDetail = ApiDomain + "BkFamilyDoctor/GetServiceDetails"
        static let checkContract = ApiDomain + "BkFamilyDoctor/CheckContractVKSOS"
        static let favoriteDoctorList = ApiDomain + "BkFamilyDoctor/GetFavoriteDoctorList"
        static let doctorListByService = ApiDomain + "BkFamilyDoctor/GetDoctorListByService"
        static let callService = ApiDomain + "BkFamilyDoctor/CallFamilyDoctorService"
        static let removeDoctor = ApiDomain + "BkFamilyDoctor/RemoveDoctorFromFavorite"
        static let addDoctor = ApiDomain + "BkFamilyDoctor/AddDoctorToFavorite"
        static let serviceStatus = ApiDomain + "BkFamilyDoctor/CheckFamilyDoctorServiceStatus"
    }
    
    struct Location {
        static let getCities = ApiDomain + "Location/GetCities"
        static let getDistricts = ApiDomain + "Location/GetDistricts"
        static let getWards = ApiDomain + "Location/GetWards"
    }

}

struct Link {
    static let _TrueconfLink = "http://vkhealth.vn/#/tcs"
    static let _MedicalTvLink = "http://yttv.vn"
}







