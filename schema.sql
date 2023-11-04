-- Create the "vet_clinic" database and switch to it.
CREATE DATABASE vet_clinic;

-- Create the "animals" table within the "vet_clinic" database.
CREATE TABLE animals (
    id serial PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    escape_attempts INTEGER,
    neutered BOOLEAN,
    weight_kg DECIMAL(5, 2)
);
