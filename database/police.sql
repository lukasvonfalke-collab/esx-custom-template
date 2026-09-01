-- Police DB additions

CREATE TABLE IF NOT EXISTS arrests (
  id INT AUTO_INCREMENT PRIMARY KEY,
  target_identifier VARCHAR(64),
  officer_identifier VARCHAR(64),
  minutes INT,
  reason VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  released TINYINT(1) DEFAULT 0,
  released_at TIMESTAMP NULL
);

CREATE TABLE IF NOT EXISTS warrants (
  id INT AUTO_INCREMENT PRIMARY KEY,
  subject_identifier VARCHAR(64),
  issuer_identifier VARCHAR(64),
  reason VARCHAR(255),
  active TINYINT(1) DEFAULT 1,
  data JSON DEFAULT '{}',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS evidence (
  id INT AUTO_INCREMENT PRIMARY KEY,
  owner_identifier VARCHAR(64),
  data JSON,
  stored_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reuse existing records table for MDT reports/warrants
