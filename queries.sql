-- 1. Find all animals whose name ends in "mon":
SELECT * FROM animals
WHERE name LIKE '%mon';

-- 2. List the name of all animals born between 2016 and 2019:
SELECT name FROM animals
WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

-- 3. List the name of all animals that are neutered and have less than 3 escape attempts:
SELECT name FROM animals
WHERE neutered = TRUE AND escape_attempts < 3;

-- 4. List the date of birth of all animals named either "Agumon" or "Pikachu":
SELECT date_of_birth FROM animals
WHERE name IN ('Agumon', 'Pikachu');

-- 5. List name and escape attempts of animals that weigh more than 10.5kg:
SELECT name, escape_attempts FROM animals
WHERE weight_kg > 10.5;

-- 6. Find all animals that are neutered:
SELECT * FROM animals
WHERE neutered = TRUE;

-- 7. Find all animals not named Gabumon:
SELECT * FROM animals
WHERE name <> 'Gabumon';

-- 8. Find all animals with a weight between 10.4kg and 17.3kg (including animals with weights that equal precisely 10.4kg or 17.3kg):
SELECT * FROM animals
WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- Start a transaction
BEGIN;

-- Update the species to "unspecified" for all animals
UPDATE animals
SET species = 'unspecified';

-- Verify the change
SELECT * FROM animals WHERE species = 'unspecified';

-- Roll back the transaction
ROLLBACK;

-- Verify that the species columns are back to their original state
SELECT * FROM animals;

-- Start a transaction
BEGIN;

-- Update the species to "digimon" for animals whose name ends in "mon"
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

-- Update the species to "pokemon" for animals with no species set
UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;

-- Verify the changes
SELECT * FROM animals;

-- Commit the transaction
COMMIT;

-- Verify that changes persist after commit
SELECT * FROM animals;

-- Start a transaction
BEGIN;

-- Delete all records in the "animals" table
DELETE FROM animals;

-- Verify if all records are deleted
SELECT * FROM animals;

-- Roll back the transaction
ROLLBACK;

-- Verify if all records in the "animals" table still exist
SELECT * FROM animals;

-- Start a transaction
BEGIN;

-- Delete animals born after Jan 1st, 2022
DELETE FROM animals WHERE date_of_birth > '2022-01-01';

-- Create a savepoint
SAVEPOINT weight_update;

-- Update all animals' weight to be their weight multiplied by -1
UPDATE animals
SET weight_kg = weight_kg * -1;

-- Rollback to the savepoint
ROLLBACK TO weight_update;

-- Update all animals' weights that are negative to be their weight multiplied by -1
UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;

-- Commit transaction
COMMIT;

-- 1. How many animals are there?
SELECT COUNT(*) AS total_animals FROM animals;

-- 2. How many animals have never tried to escape?
SELECT COUNT(*) AS animals_never_escaped
FROM animals
WHERE escape_attempts = 0;

-- 3. What is the average weight of animals?
SELECT AVG(weight_kg) AS average_weight
FROM animals;

-- 4. Who escapes the most, neutered or not neutured animals?
SELECT neutered, MAX(escape_attempts) AS max_escape_attempts
FROM animals
GROUP BY neutered;

-- 5. What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight
FROM animals
GROUP BY species;

-- 6. What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) AS avg_escape_attempts
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

-- 1. What animals belong to Melody Pond?
SELECT a.name
FROM owners o
JOIN animals a ON o.id = a.owner_id
WHERE o.full_name = 'Melody Pond';

-- 2. List of all animals that are Pokemon (their type is Pokemon).
SELECT a.name
FROM animals a
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Pokemon';

-- 3. List all owners and their animals, including those who don't own any animals.
SELECT o.full_name, a.name
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id;

-- 4. How many animals are there per species?
SELECT s.name AS species, COUNT(a.id) AS animal_count
FROM species s
LEFT JOIN animals a ON s.id = a.species_id
GROUP BY s.name;

-- 5. List all Digimon owned by Jennifer Orwell.
SELECT a.name
FROM owners o
JOIN animals a ON o.id = a.owner_id
JOIN species s ON a.species_id = s.id
WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';

-- 6. List all animals owned by Dean Winchester that haven't tried to escape.
SELECT a.name
FROM owners o
JOIN animals a ON o.id = a.owner_id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;

-- 7. Who owns the most animals?
SELECT o.full_name, COUNT(a.id) AS animal_count
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id
GROUP BY o.full_name
ORDER BY animal_count DESC
LIMIT 1;

-- 1. Who was the last animal seen by William Tatcher?
SELECT a.name
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'William Tatcher'
ORDER BY v.visit_date DESC
LIMIT 1;

-- 2. How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT v.animal_id) AS num_animals
FROM visits v
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'Stephanie Mendez';

-- 3. List all vets and their specialties, including vets with no specialties.
SELECT vt.name, COALESCE(s.name, 'No Specialty') AS specialty
FROM vets vt
LEFT JOIN specializations sp ON vt.id = sp.vet_id
LEFT JOIN species s ON sp.species_id = s.id;

-- 4. List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'Stephanie Mendez'
AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- 5. What animal has the most visits to vets?
SELECT a.name, COUNT(v.animal_id) AS num_visits
FROM visits v
JOIN animals a ON v.animal_id = a.id
GROUP BY a.name
ORDER BY num_visits DESC
LIMIT 1;

-- 6. Who was Maisy Smith's first visit?
SELECT a.name
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'Maisy Smith'
ORDER BY v.visit_date
LIMIT 1;

-- 7. Details for the most recent visit: animal information, vet information, and date of visit.
SELECT a.name AS animal_name, vt.name AS vet_name, v.visit_date
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets vt ON v.vet_id = vt.id
ORDER BY v.visit_date DESC
LIMIT 1;

-- 8. How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) AS num_visits
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets vt ON v.vet_id = vt.id
LEFT JOIN specializations sp ON vt.id = sp.vet_id
WHERE sp.species_id IS NULL OR sp.species_id != a.species_id;

-- 9. What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name
FROM species
JOIN animals
ON species.id = animals.species_id
JOIN visits
ON animals.id = animal_id
JOIN vets
ON vet_id = vets.id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name
ORDER BY COUNT(*) DESC LIMIT 1;

