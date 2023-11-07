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

-- Add the "species" column of type string to the "animals" table.
ALTER TABLE animals
ADD COLUMN species VARCHAR(255);

CREATE TABLE owners (
    id serial PRIMARY KEY,
    full_name VARCHAR(255),
    age INTEGER
);

CREATE TABLE species (
    id serial PRIMARY KEY,
    name VARCHAR(255)
);

-- Remove the existing "species" column
ALTER TABLE animals
DROP COLUMN species;

-- Add a new column "species_id" as a foreign key referencing the "species" table
ALTER TABLE animals
ADD COLUMN species_id INTEGER;

-- Add a new column "owner_id" as a foreign key referencing the "owners" table
ALTER TABLE animals
ADD COLUMN owner_id INTEGER;

-- Set "id" as an auto-incremented primary key
ALTER TABLE animals
ALTER COLUMN id SET DEFAULT nextval('animals_id_seq');

-- Add foreign key constraints
ALTER TABLE animals
ADD CONSTRAINT fk_species
FOREIGN KEY (species_id)
REFERENCES species(id);

ALTER TABLE animals
ADD CONSTRAINT fk_owner
FOREIGN KEY (owner_id)
REFERENCES owners(id);


CREATE TABLE vets (
    id serial PRIMARY KEY,
    name VARCHAR(255),
    age INTEGER,
    date_of_graduation DATE
);

CREATE TABLE specializations (
    vet_id INTEGER,
    species_id INTEGER,
    PRIMARY KEY (vet_id, species_id),
    FOREIGN KEY (vet_id) REFERENCES vets (id),
    FOREIGN KEY (species_id) REFERENCES species (id)
);

CREATE TABLE visits (
    animal_id INTEGER,
    vet_id INTEGER,
    visit_date DATE,
    PRIMARY KEY (animal_id, vet_id, visit_date),
    FOREIGN KEY (animal_id) REFERENCES animals (id),
    FOREIGN KEY (vet_id) REFERENCES vets (id)
);

ALTER TABLE visits
ADD COLUMN id SERIAL;

-- Rename visit_date column to date_of_visit
ALTER TABLE visits RENAME COLUMN visit_date TO date_of_visit;

ALTER TABLE visits
ADD PRIMARY KEY (id);

CREATE TABLE new_visits (
    id SERIAL PRIMARY KEY,
    animal_id INTEGER,
    vet_id INTEGER,
    date_of_visit DATE,
    FOREIGN KEY (animal_id) REFERENCES animals (id),
    FOREIGN KEY (vet_id) REFERENCES vets (id)
);

INSERT INTO new_visits (animal_id, vet_id, date_of_visit)
SELECT animal_id, vet_id, date_of_visit
FROM visits;

-- Drop the old 'visits' table
DROP TABLE visits;

-- Rename the new 'new_visits' table to 'visits'
ALTER TABLE new_visits RENAME TO visits;

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

/* ===========
 Create indexes on email, vet_id, and animal_id columns for optimization
 =========== */
--  Create an index on the `animal_id` column in the `visits` table
CREATE INDEX idx_animal_id
ON visits (animal_id);

--  Create an index on the `vet_id` column in the `visits` table
CREATE INDEX idx_vet_id
ON visits (vet_id);

--  Create an index on the `email` column of the `owners` table
CREATE INDEX idx_email
ON owners (email);
