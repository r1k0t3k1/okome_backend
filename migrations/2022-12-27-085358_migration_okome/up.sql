CREATE SCHEMA "okome";

CREATE TABLE "okome"."users" (
  "user_id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "user_name" varchar(30),
  "email" varchar(319),
  "group_id" int,
  "created_at" timestamp NOT NULL,
  "updated_at" timestamp
);

CREATE TABLE "okome"."user_credentials" (
  "user_id" int,
  "password_hash" varchar(512) UNIQUE NOT NULL,
  "salt" varchar(32) UNIQUE NOT NULL,
  "consecutive_login_failure" int DEFAULT 0,
  "created_at" timestamp NOT NULL,
  "updated_at" timestamp
);

CREATE TABLE "okome"."user_settings" (
  "user_id" int,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "okome"."groups" (
  "group_id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "group_name" varchar(30) NOT NULL,
  "created_at" timestamp NOT NULL,
  "updated_at" timestamp
);

CREATE TABLE "okome"."assesments" (
  "assesment_id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "site_id" int,
  "start_date" timestamp,
  "end_date" timestamp,
  "submission_deadline" timestamp,
  "group_in_charge" int,
  "created_at" timestamp NOT NULL,
  "updated_at" timestamp
);

CREATE TABLE "okome"."assesment_urls" (
  "url_id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "assesment_id" int,
  "url" text NOT NULL,
  "http_method_id" int,
  "created_at" timestamp NOT NULL,
  "updated_at" timestamp
);

CREATE TABLE "okome"."http_methods" (
  "http_method_id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "http_method_name" varchar(10) NOT NULL,
  "created_at" timestamp NOT NULL,
  "updated_at" timestamp
);

CREATE TABLE "okome"."request_parameters" (
  "parameter_id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "parameter_name" text NOT NULL,
  "url_id" int,
  "parameter_type_id" int,
  "comment" text,
  "user_in_charge" int,
  "is_vulnerable" boolean DEFAULT false,
  "is_completed" boolean DEFAULT false,
  "created_at" timestamp NOT NULL,
  "updated_at" timestamp
);

CREATE TABLE "okome"."parameter_types" (
  "parameter_type_id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "parameter_type" varchar(50) NOT NULL,
  "created_at" timestamp NOT NULL,
  "updated_at" timestamp
);

CREATE TABLE "okome"."sites" (
  "site_id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "site_name" varchar(50) NOT NULL,
  "domain" varchar(253) NOT NULL,
  "customer_id" int,
  "created_at" timestamp NOT NULL,
  "updated_at" timestamp
);

CREATE TABLE "okome"."customers" (
  "customer_id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "customer_name" varchar(50) NOT NULL,
  "primary_in_charge_name" varchar(30),
  "secondaly_in_charge_name" varchar(30),
  "primary_in_charge_email" varchar(30),
  "secondaly_in_charge_email" varchar(30),
  "created_at" timestamp NOT NULL,
  "updated_at" timestamp
);

CREATE TABLE "okome"."vulnerablities" (
  "vulnerablity_id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "vulnerablity_title" text,
  "vulnerablity_description" text,
  "vulnerablity_category" int,
  "parameter_id" int,
  "severity_id" int,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "okome"."severities" (
  "severity_id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "severity" varchar(15),
  "severity_japanese" varchar(15),
  "severity_lower_limit" float,
  "severity_higher_limit" float,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "okome"."cwes" (
  "cwe_id" int PRIMARY KEY,
  "cwe_name" text,
  "cwe_description" text,
  "cwe_weekness" text,
  "cwe_status" text,
  "cwe_extended_description" text,
  "cwe_related_weakness" text,
  "cwe_weekness_ordinalities" text,
  "cwe_applicable_platforms" text,
  "cwe_background_details" text,
  "cwe_alternate_terms" text,
  "cwe_modes_of_introduction" text,
  "cwe_exploitation_factors" text,
  "cwe_likelihood_of_exploit" text,
  "cwe_common_consequenses" text,
  "cwe_detection_methods" text,
  "cwe_potential_mitigations" text,
  "cwe_observed_examples" text,
  "cwe_functional_areas" text,
  "cwe_affected_resources" text,
  "cwe_taxonomy_mappings" text,
  "cwe_related_attack_patterns" text,
  "cwe_notes" text
);

ALTER TABLE "okome"."users" ADD FOREIGN KEY ("group_id") REFERENCES "okome"."groups" ("group_id");

ALTER TABLE "okome"."user_credentials" ADD FOREIGN KEY ("user_id") REFERENCES "okome"."users" ("user_id");

ALTER TABLE "okome"."user_settings" ADD FOREIGN KEY ("user_id") REFERENCES "okome"."users" ("user_id");

ALTER TABLE "okome"."assesments" ADD FOREIGN KEY ("site_id") REFERENCES "okome"."sites" ("site_id");

ALTER TABLE "okome"."assesments" ADD FOREIGN KEY ("group_in_charge") REFERENCES "okome"."groups" ("group_id");

ALTER TABLE "okome"."assesment_urls" ADD FOREIGN KEY ("assesment_id") REFERENCES "okome"."assesments" ("assesment_id");

ALTER TABLE "okome"."assesment_urls" ADD FOREIGN KEY ("http_method_id") REFERENCES "okome"."http_methods" ("http_method_id");

ALTER TABLE "okome"."request_parameters" ADD FOREIGN KEY ("url_id") REFERENCES "okome"."assesment_urls" ("url_id");

ALTER TABLE "okome"."request_parameters" ADD FOREIGN KEY ("parameter_type_id") REFERENCES "okome"."parameter_types" ("parameter_type_id");

ALTER TABLE "okome"."request_parameters" ADD FOREIGN KEY ("user_in_charge") REFERENCES "okome"."users" ("user_id");

ALTER TABLE "okome"."sites" ADD FOREIGN KEY ("customer_id") REFERENCES "okome"."customers" ("customer_id");

ALTER TABLE "okome"."vulnerablities" ADD FOREIGN KEY ("vulnerablity_category") REFERENCES "okome"."cwes" ("cwe_id");

ALTER TABLE "okome"."vulnerablities" ADD FOREIGN KEY ("parameter_id") REFERENCES "okome"."request_parameters" ("parameter_id");

ALTER TABLE "okome"."vulnerablities" ADD FOREIGN KEY ("severity_id") REFERENCES "okome"."severities" ("severity_id");