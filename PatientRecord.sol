// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PatientRecord {
    
    struct Patient {
        uint patientId;
        address patAddress;
        string name;
        uint age;
    }

    struct Doctor {
        uint doctorId;
        string docName;
        string speciality;
        address docAddress;
        string addres;
    }
    struct Disease {
        string name;
    }

    struct Medicine {
        uint medicineId;
        string name;
        string dateOfExp;
        uint dose;
        uint price;
    }

    mapping(uint => Patient) patientsById;
    mapping(address => Patient) patientsByAddress;
    mapping(uint => Doctor) doctors;
    mapping(uint => Medicine) medicines;
    mapping(address=>Disease) diseases;
    mapping(address=>Medicine) presMed;
 

    event PatientAdded(uint patientId, address patAddress, string name, uint age);
    event DoctorAdded(uint doctorId, string docName, string speciality, address docAddress, string addres);
    event DiseaseAdded(string name);
    event MedicineAdded(uint medicineId, string name, string dateOfExp, uint dose, uint price);
    event MedicinePrescribed(uint medicineId, uint patientId);
    event PatientDetailsUpdated(uint patientId, uint newAge);
    
    function regDoctor (uint _docId, string memory _docName, string memory _spec, string memory _address) public {
        Doctor memory doc = Doctor(_docId, _docName, _spec, msg.sender, _address);
        doctors[_docId] = doc;
        emit DoctorAdded(_docId, _docName, _spec, msg.sender, _address);
    }
    
    function regPatient(uint _pId, string memory _name, uint _age) public {
        require(patientsById[_pId].age == 0, "Patient already exists");
        Patient memory pat = Patient(_pId, msg.sender, _name, _age);
        patientsById[_pId] = pat;
        patientsByAddress[msg.sender] = pat;
        emit PatientAdded(_pId, msg.sender, _name, _age);
    }

    function addDisease(string memory _name, uint _pId) public { 
    require(msg.sender == patientsById[_pId].patAddress, "Not Your data");
    Disease memory dis = Disease(_name);
    diseases[msg.sender] = dis;
    emit DiseaseAdded(_name);
    }

    function addMedicine (uint _mId, string memory _name, string memory _exp, uint _dose, uint _price) public {
        require(medicines[_mId].price == 0, "Medicine already exists");
        Medicine memory newMed = Medicine(_mId, _name, _exp, _dose, _price);
        medicines[_mId] = newMed;

        emit MedicineAdded(_mId, _name, _exp, _dose, _price);
    }

    function prescribeMedicine (uint _mId, uint _pId, uint _docId) public {
        require(msg.sender == doctors[_docId].docAddress, "Doctor does not exist");
        presMed[patientsById[_pId].patAddress] = medicines[_mId];
        emit MedicinePrescribed(_mId, _pId);
    }

    function updateDetails (uint _age, uint _pId) public {
        require(patientsById[_pId].patAddress == msg.sender, "Not authorized");
        patientsById[_pId].age = _age;
        emit PatientDetailsUpdated(_pId, _age);
    }

    function patientDetailByDoctor (uint _pId, uint _docId) public view returns (Patient memory){
        require(msg.sender == doctors[_docId].docAddress);
        
        return patientsById[_pId];
    }

    function prescribedMedicine (uint _docId, uint _pId) public  view returns (Medicine memory) {
        require(msg.sender == doctors[_docId].docAddress);
        return presMed[patientsById[_pId].patAddress];
    }
    
    function showPatientDetail (uint _pId) public view returns ( uint,uint,string memory , Disease memory){
        require(msg.sender == patientsById[_pId].patAddress, "Not authorized");
        return (patientsById[_pId].patientId , patientsById[_pId].age , patientsById[_pId].name , diseases[msg.sender]);
    }

    function medicineDetail (uint _mId) public view returns (Medicine memory){
        require(medicines[_mId].medicineId!=0,"Medicine does not exist");
        return(medicines[_mId]);
    }

    function docDetails (uint _docId) public view returns (Doctor memory){
        return(doctors[_docId]);
    }
}