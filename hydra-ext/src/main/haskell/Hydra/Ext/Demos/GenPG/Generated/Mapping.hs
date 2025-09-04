module Hydra.Ext.Demos.GenPG.Generated.Mapping where

import Hydra.Core (Term)
import Hydra.Pg.Model (Edge, Vertex)
import Hydra.Formatting (decapitalize)
import Hydra.Phantoms (TTerm)
import Hydra.Dsl.Phantoms ((@@), constant, just, lambda, nothing, string, var)
import Hydra.Ext.Dsl.Pg.Mappings (LazyGraph, column, edge, edgeNoId, graph, property, vertex)
import qualified Hydra.Dsl.Lib.Literals as Literals
import qualified Hydra.Dsl.Lib.Optionals as Optionals
import qualified Hydra.Dsl.Lib.Strings as Strings
import Hydra.Ext.Demos.GenPG.Generated.GraphSchema

-- Generated mapping for the health/copilot dataset
-- This maps CSV data to the property graph structure

-- Helpers -----------------------

labeledIntId :: String -> TTerm (r -> Maybe Int) -> TTerm (r -> String)
labeledIntId itype iid = lambda "r" $ Optionals.map
  (lambda "i" $ Strings.concat [
    string $ decapitalize itype,
    string "_",
    Literals.showInt32 $ var "i"])
  (iid @@ var "r")

-- Mapping -----------------------------

generatedGraphMapping :: LazyGraph Term
generatedGraphMapping = graph
  -- Vertices
  [vertex "patients.csv" patientVertexLabel (labeledIntId patientVertexLabel $ column "patient_id") [
     property "firstName" $ column "first_name",
     property "lastName" $ column "last_name",
     property "dateOfBirth" $ column "date_of_birth",
     property "gender" $ column "gender",
     property "email" $ column "email",
     property "phone" $ column "phone",
     property "address" $ column "address",
     property "emergencyContact" $ column "emergency_contact",
     property "insuranceProvider" $ column "insurance_provider",
     property "policyNumber" $ column "policy_number"],

   vertex "doctors.csv" doctorVertexLabel (labeledIntId doctorVertexLabel $ column "doctor_id") [
     property "firstName" $ column "first_name",
     property "lastName" $ column "last_name",
     property "specialty" $ column "specialty",
     property "email" $ column "email",
     property "phone" $ column "phone",
     property "licenseNumber" $ column "license_number",
     property "yearsExperience" $ column "years_experience"],

   vertex "departments.csv" departmentVertexLabel (labeledIntId departmentVertexLabel $ column "department_id") [
     property "name" $ column "department_name",
     property "location" $ column "location"],

   vertex "appointments.csv" appointmentVertexLabel (labeledIntId appointmentVertexLabel $ column "appointment_id") [
     property "appointmentDate" $ column "appointment_date",
     property "appointmentTime" $ column "appointment_time",
     property "durationMinutes" $ column "duration_minutes",
     property "appointmentType" $ column "appointment_type",
     property "status" $ column "status",
     property "notes" $ column "notes"],

   vertex "prescriptions.csv" prescriptionVertexLabel (labeledIntId prescriptionVertexLabel $ column "prescription_id") [
     property "medicationName" $ column "medication_name",
     property "dosage" $ column "dosage",
     property "frequency" $ column "frequency",
     property "durationDays" $ column "duration_days",
     property "instructions" $ column "instructions",
     property "refillsRemaining" $ column "refills_remaining"],

   vertex "vitals.csv" vitalVertexLabel (labeledIntId vitalVertexLabel $ column "vital_id") [
     property "bloodPressureSystolic" $ column "blood_pressure_systolic",
     property "bloodPressureDiastolic" $ column "blood_pressure_diastolic",
     property "heartRate" $ column "heart_rate",
     property "temperature" $ column "temperature",
     property "weight" $ column "weight",
     property "height" $ column "height",
     property "notes" $ column "notes"]]

  -- Edges
  [edgeNoId "appointments.csv" hasAppointmentEdgeLabel
     (labeledIntId patientVertexLabel $ column "patient_id")
     (labeledIntId appointmentVertexLabel $ column "appointment_id")
     [],

   edgeNoId "appointments.csv" attendedByEdgeLabel
     (labeledIntId appointmentVertexLabel $ column "appointment_id")
     (labeledIntId doctorVertexLabel $ column "doctor_id")
     [],

   edgeNoId "doctors.csv" belongsToDepartmentEdgeLabel
     (labeledIntId doctorVertexLabel $ column "doctor_id")
     (labeledIntId departmentVertexLabel $ column "department_id")
     [],

   edgeNoId "departments.csv" headsEdgeLabel
     (labeledIntId doctorVertexLabel $ column "head_doctor_id")
     (labeledIntId departmentVertexLabel $ column "department_id")
     [],

   edgeNoId "prescriptions.csv" prescribedEdgeLabel
     (labeledIntId appointmentVertexLabel $ column "appointment_id")
     (labeledIntId prescriptionVertexLabel $ column "prescription_id")
     [],

   edgeNoId "vitals.csv" measuredEdgeLabel
     (labeledIntId appointmentVertexLabel $ column "appointment_id")
     (labeledIntId vitalVertexLabel $ column "vital_id")
     []]
