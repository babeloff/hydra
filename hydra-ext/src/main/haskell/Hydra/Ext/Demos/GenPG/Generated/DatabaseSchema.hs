module Hydra.Ext.Demos.GenPG.Generated.DatabaseSchema where

import Hydra.Dsl.Tabular (TableType, tableType, columnType)
import Hydra.Dsl.Types (binary, boolean, float32, float64, int32, int64, string)

-- Generated table schemas for the health/copilot dataset
-- These correspond to the CSV files in data/genpg/sources/health/

patientsTableType :: TableType
patientsTableType = tableType "patients.csv" [
  columnType "patient_id" int32,
  columnType "first_name" string,
  columnType "last_name" string,
  columnType "date_of_birth" string,
  columnType "gender" string,
  columnType "email" string,
  columnType "phone" string,
  columnType "address" string,
  columnType "emergency_contact" string,
  columnType "insurance_provider" string,
  columnType "policy_number" string]

doctorsTableType :: TableType
doctorsTableType = tableType "doctors.csv" [
  columnType "doctor_id" int32,
  columnType "first_name" string,
  columnType "last_name" string,
  columnType "specialty" string,
  columnType "email" string,
  columnType "phone" string,
  columnType "license_number" string,
  columnType "years_experience" int32,
  columnType "department_id" int32]

departmentsTableType :: TableType
departmentsTableType = tableType "departments.csv" [
  columnType "department_id" int32,
  columnType "department_name" string,
  columnType "location" string,
  columnType "head_doctor_id" int32]

appointmentsTableType :: TableType
appointmentsTableType = tableType "appointments.csv" [
  columnType "appointment_id" int32,
  columnType "patient_id" int32,
  columnType "doctor_id" int32,
  columnType "appointment_date" string,
  columnType "appointment_time" string,
  columnType "duration_minutes" int32,
  columnType "appointment_type" string,
  columnType "status" string,
  columnType "notes" string]

prescriptionsTableType :: TableType
prescriptionsTableType = tableType "prescriptions.csv" [
  columnType "prescription_id" int32,
  columnType "appointment_id" int32,
  columnType "medication_name" string,
  columnType "dosage" string,
  columnType "frequency" string,
  columnType "duration_days" int32,
  columnType "instructions" string,
  columnType "refills_remaining" int32]

vitalsTableType :: TableType
vitalsTableType = tableType "vitals.csv" [
  columnType "vital_id" int32,
  columnType "appointment_id" int32,
  columnType "blood_pressure_systolic" int32,
  columnType "blood_pressure_diastolic" int32,
  columnType "heart_rate" int32,
  columnType "temperature" float64,
  columnType "weight" float64,
  columnType "height" float64,
  columnType "notes" string]

generatedTableSchemas :: [TableType]
generatedTableSchemas = [
  patientsTableType,
  doctorsTableType,
  departmentsTableType,
  appointmentsTableType,
  prescriptionsTableType,
  vitalsTableType]
