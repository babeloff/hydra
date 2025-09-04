module Hydra.Ext.Demos.GenPG.Generated.GraphSchema where

import Hydra.Ext.Dsl.Pg.Schemas (propertyType, required, schema, simpleEdgeType, vertexType)
import Hydra.Dsl.Types (binary, boolean, float32, float64, int32, int64, string)

-- Generated graph schema for the health/copilot dataset
-- This corresponds to the health domain data structure

dateType = string
decimalType = float64

-- Vertex labels -----------------------

patientVertexLabel = "Patient"
doctorVertexLabel = "Doctor"
departmentVertexLabel = "Department"
appointmentVertexLabel = "Appointment"
prescriptionVertexLabel = "Prescription"
vitalVertexLabel = "Vital"

-- Edge labels -------------------------

treatedByEdgeLabel = "treatedBy"
belongsToDepartmentEdgeLabel = "belongsToDepartment"
headsEdgeLabel = "heads"
hasAppointmentEdgeLabel = "hasAppointment"
attendedByEdgeLabel = "attendedBy"
prescribedEdgeLabel = "prescribed"
measuredEdgeLabel = "measured"

-- Graph Schema ------------------------

generatedGraphSchema = schema vertexTypes edgeTypes
  where
    vertexTypes = [
      vertexType patientVertexLabel int32 [
        required $ propertyType "firstName" string,
        required $ propertyType "lastName" string,
        propertyType "dateOfBirth" dateType,
        propertyType "gender" string,
        propertyType "email" string,
        propertyType "phone" string,
        propertyType "address" string,
        propertyType "emergencyContact" string,
        propertyType "insuranceProvider" string,
        propertyType "policyNumber" string],

      vertexType doctorVertexLabel int32 [
        required $ propertyType "firstName" string,
        required $ propertyType "lastName" string,
        required $ propertyType "specialty" string,
        propertyType "email" string,
        propertyType "phone" string,
        propertyType "licenseNumber" string,
        propertyType "yearsExperience" int32],

      vertexType departmentVertexLabel int32 [
        required $ propertyType "name" string,
        propertyType "location" string],

      vertexType appointmentVertexLabel int32 [
        required $ propertyType "appointmentDate" dateType,
        required $ propertyType "appointmentTime" string,
        propertyType "durationMinutes" int32,
        propertyType "appointmentType" string,
        propertyType "status" string,
        propertyType "notes" string],

      vertexType prescriptionVertexLabel int32 [
        required $ propertyType "medicationName" string,
        propertyType "dosage" string,
        propertyType "frequency" string,
        propertyType "durationDays" int32,
        propertyType "instructions" string,
        propertyType "refillsRemaining" int32],

      vertexType vitalVertexLabel int32 [
        propertyType "bloodPressureSystolic" int32,
        propertyType "bloodPressureDiastolic" int32,
        propertyType "heartRate" int32,
        propertyType "temperature" decimalType,
        propertyType "weight" decimalType,
        propertyType "height" decimalType,
        propertyType "notes" string]]

    edgeTypes = [
      simpleEdgeType hasAppointmentEdgeLabel patientVertexLabel appointmentVertexLabel [],

      simpleEdgeType attendedByEdgeLabel appointmentVertexLabel doctorVertexLabel [],

      simpleEdgeType belongsToDepartmentEdgeLabel doctorVertexLabel departmentVertexLabel [],

      simpleEdgeType headsEdgeLabel doctorVertexLabel departmentVertexLabel [],

      simpleEdgeType prescribedEdgeLabel appointmentVertexLabel prescriptionVertexLabel [],

      simpleEdgeType measuredEdgeLabel appointmentVertexLabel vitalVertexLabel []]
