-- CLASS
INSERT INTO public.class(name, year)
VALUES ('1AHITN', '2024/25'),
       ('2AHITN', '2024/25'),
       ('3AHITN', '2024/25'),
       ('4AHITN', '2024/25'),

       ('1AHEL', '2024/25'),
       ('2AHEL', '2024/25'),
       ('3AHEL', '2024/25'),
       ('4AHEL', '2024/25'),

       ('1AHME', '2024/25'),
       ('2AHME', '2024/25'),
       ('3AHME', '2024/25'),
       ('4AHME', '2024/25'),

       ('1BHME', '2024/25'),
       ('2BHME', '2024/25'),
       ('3BHME', '2024/25'),
       ('4BHME', '2024/25'),

       ('1AHMBZ', '2024/25'),
       ('2AHMBZ', '2024/25'),
       ('3AHMBZ', '2024/25'),
       ('4AHMBZ', '2024/25'),

       ('1BHMBZ', '2024/25'),
       ('2BHMBZ', '2024/25'),
       ('3BHMBZ', '2024/25'),
       ('4BHMBZ', '2024/25'),

       ('1YHKUG', '2024/25'),
       ('2YHKUG', '2024/25'),
       ('3YHKUG', '2024/25'),
       ('4YHKUG', '2024/25'),

       ('1YHKUJ', '2024/25'),
       ('2YHKUJ', '2024/25'),
       ('3YHKUJ', '2024/25'),
       ('4YHKUJ', '2024/25'),

       ('1YHKUP', '2024/25'),
       ('2YHKUP', '2024/25'),
       ('3YHKUP', '2024/25'),
       ('4YHKUP', '2024/25'),

       ('1AFMBZ', '2024/25'),
       ('2AFMBZ', '2024/25'),
       ('3AFMBZ', '2024/25'),
       ('4AFMBZ', '2024/25');

-- LOGOS
INSERT INTO "public"."logo" ("id", "name", "image_path")
VALUES ('00e6f81c-b06b-4390-a1a4-7062883e708b', 'Spinne', '/logos/mite.svg'),
       ('01a8ae40-0f45-48dd-9df2-496071f32095', 'Hai', '/logos/shark-jaws.svg'),
       ('0e1dc401-29cd-4949-94bf-f9b8833bfb51', 'Tiger', '/logos/tiger-head.svg'),
       ('1036a5f4-3a7c-410e-b46f-82300b867603', 'Tornado', '/logos/whirlwind.svg'),
       ('3b7d96d7-29ee-42b1-abb1-ad5b1a4da69f', 'Wolf', '/logos/wolf-head.svg'),
       ('3d2289fb-042f-487c-a62d-989e0c08957f', 'Bison', '/logos/bison.svg'),
       ('44e5f640-50c7-42df-8d39-fee97ecbbf1f', 'Herz', '/logos/heartburn.svg'),
       ('5327dfe6-1dca-4ee4-801c-72e1c6a6eb99', 'Krone', '/logos/crowned-skull.svg'),
       ('5d9e070b-28aa-4be9-b6a1-3b647a709124', 'Schädel', '/logos/desert-skull.svg'),
       ('5eb74ea0-8668-429e-981a-51f2d50d2fc0', 'Paladin', '/logos/closed-barbute.svg'),
       ('61d4ec76-77df-4458-b694-e47e79d123d3', 'Flügel', '/logos/curly-wing.svg'),
       ('621316ea-a2d9-44c4-96fe-d9e80d0a7ba9', 'Wyvern', '/logos/wyvern.svg'),
       ('888c459b-6a27-4b1e-bf4a-460072f8a2ba', 'Schwert', '/logos/relic-blade.svg'),
       ('8db73609-4a95-4b66-aaf0-6dbee2d24a68', 'Drache', '/logos/dragon-head.svg'),
       ('908a5d67-86db-40e3-a6e4-e55b205974f4', 'Turm', '/logos/stone-tower.svg'),
       ('b0ed5200-fccf-48c5-b14b-64c28250b518', 'Feuer', '/logos/small-fire.svg'),
       ('d89129a6-6325-40e7-b074-398455aeee75', 'Schild', '/logos/checked-shield.svg'),
       ('e208994e-90f7-4328-99a3-34e95f91dbe8', 'Pferd', '/logos/horse-head.svg'),
       ('e6320a62-ef27-4744-a6a3-62d4dbf826cb', 'Engel', '/logos/angel-outfit.svg'),
       ('eed808b8-2bd2-4cd9-8100-5f4df404b909', 'Klaue', '/logos/bird-claw.svg');

-- VARIANTS
-- TODO: remove id, this was just exported but whatever
INSERT INTO "public"."logo_variant" ("id", "color", "image_path", "logo_id")
VALUES ('01a8ae40-0f45-48dd-9df2-496071f32095', 'Rot', '/variants/red/shark-jaws-red.svg',
        '01a8ae40-0f45-48dd-9df2-496071f32095'),
       ('0e1dc401-29cd-4949-94bf-f9b8833bfb51', 'Rot', '/variants/red/tiger-head-red.svg',
        '0e1dc401-29cd-4949-94bf-f9b8833bfb51'),
       ('1036a5f4-3a7c-410e-b46f-82300b867603', 'Rot', '/variants/red/whirlwind-red.svg',
        '1036a5f4-3a7c-410e-b46f-82300b867603'),
       ('227209b2-8981-429f-a086-b1043e7c4f31', 'Grün', '/variants/green/wolf-head-green.svg',
        '3b7d96d7-29ee-42b1-abb1-ad5b1a4da69f'),
       ('292d92ab-2444-42d3-bf75-e9b6993e5ab7', 'Blau', '/variants/blue/bison-blue.svg',
        '3d2289fb-042f-487c-a62d-989e0c08957f'),
       ('297e5339-4e63-483b-a88e-2f35f59c6779', 'Rot', '/variants/red/mite-red.svg',
        '00e6f81c-b06b-4390-a1a4-7062883e708b'),
       ('2b7042a5-6232-4297-a360-b2e6e1b6b1b1', 'Pride', '/variants/pride/crowned-skull-pride.svg',
        '5327dfe6-1dca-4ee4-801c-72e1c6a6eb99'),
       ('2b711dd5-b6f5-47a5-949a-d923f02ac313', 'Grün', '/variants/green/wyvern-green.svg',
        '621316ea-a2d9-44c4-96fe-d9e80d0a7ba9'),
       ('3a8d8000-e104-4e7f-bb7d-34b0e4e7b8da', 'Grün', '/variants/green/whirlwind-green.svg',
        '1036a5f4-3a7c-410e-b46f-82300b867603'),
       ('3b7d96d7-29ee-42b1-abb1-ad5b1a4da69f', 'Rot', '/variants/red/wolf-head-red.svg',
        '3b7d96d7-29ee-42b1-abb1-ad5b1a4da69f'),
       ('3bc837ee-83fb-47a5-9e82-d8d019417bc4', 'Grün', '/variants/green/relic-blade-green.svg',
        '888c459b-6a27-4b1e-bf4a-460072f8a2ba'),
       ('3d2289fb-042f-487c-a62d-989e0c08957f', 'Rot', '/variants/red/bison-red.svg',
        '3d2289fb-042f-487c-a62d-989e0c08957f'),
       ('437e6ef5-f2b5-457b-bff2-c2d9d7f4b5c2', 'Pride', '/variants/pride/closed-barbute-pride.svg',
        '5eb74ea0-8668-429e-981a-51f2d50d2fc0'),
       ('441f79f5-d1b2-4d5a-8efb-dedca207d586', 'Pride', '/variants/pride/horse-head-pride.svg',
        'e208994e-90f7-4328-99a3-34e95f91dbe8'),
       ('44e5f640-50c7-42df-8d39-fee97ecbbf1f', 'Rot', '/variants/red/heartburn-red.svg',
        '44e5f640-50c7-42df-8d39-fee97ecbbf1f'),
       ('45fa2064-df1f-4e73-a8db-78127dbdfd22', 'Grün', '/variants/green/tiger-head-green.svg',
        '0e1dc401-29cd-4949-94bf-f9b8833bfb51'),
       ('48998b7c-8a70-41bb-bc9c-daa170472b94', 'Blau', '/variants/blue/dragon-head-blue.svg',
        '8db73609-4a95-4b66-aaf0-6dbee2d24a68'),
       ('4b9d9f1a-f968-47a1-b5b3-d0b964f3d0d2', 'Blau', '/variants/blue/desert-skull-blue.svg',
        '5d9e070b-28aa-4be9-b6a1-3b647a709124'),
       ('4d3d3c6f-30ff-49a2-83fa-d21ff631ee06', 'Pride', '/variants/pride/heartburn-pride.svg',
        '44e5f640-50c7-42df-8d39-fee97ecbbf1f'),
       ('4efb8e0f-dc90-48d2-a2ea-44b3c43e5064', 'Pride', '/variants/pride/stone-tower-pride.svg',
        '908a5d67-86db-40e3-a6e4-e55b205974f4'),
       ('50316ef0-dfc5-46f2-a243-c55f32a65ae0', 'Pride', '/variants/pride/bird-claw-pride.svg',
        'eed808b8-2bd2-4cd9-8100-5f4df404b909'),
       ('5327dfe6-1dca-4ee4-801c-72e1c6a6eb99', 'Rot', '/variants/red/crowned-skull-red.svg',
        '5327dfe6-1dca-4ee4-801c-72e1c6a6eb99'),
       ('55b7f90b-5f75-45c1-89d5-7d64c7a98d5e', 'Grün', '/variants/green/angel-outfit-green.svg',
        'e6320a62-ef27-4744-a6a3-62d4dbf826cb'),
       ('5d9e070b-28aa-4be9-b6a1-3b647a709124', 'Rot', '/variants/red/desert-skull-red.svg',
        '5d9e070b-28aa-4be9-b6a1-3b647a709124'),
       ('5eb74ea0-8668-429e-981a-51f2d50d2fc0', 'Rot', '/variants/red/closed-barbute-red.svg',
        '5eb74ea0-8668-429e-981a-51f2d50d2fc0'),
       ('5f24a57d-cbe1-4112-bae7-b49aaf902c7e', 'Blau', '/variants/blue/wyvern-blue.svg',
        '621316ea-a2d9-44c4-96fe-d9e80d0a7ba9'),
       ('5fa5cfd1-caf8-4c7f-8a18-2768e2788762', 'Blau', '/variants/blue/horse-head-blue.svg',
        'e208994e-90f7-4328-99a3-34e95f91dbe8'),
       ('61d4ec76-77df-4458-b694-e47e79d123d3', 'Rot', '/variants/red/curly-wing-red.svg',
        '61d4ec76-77df-4458-b694-e47e79d123d3'),
       ('621316ea-a2d9-44c4-96fe-d9e80d0a7ba9', 'Rot', '/variants/red/wyvern-red.svg',
        '621316ea-a2d9-44c4-96fe-d9e80d0a7ba9'),
       ('63179f34-c9c5-40e4-9057-df5c0c88f40e', 'Grün', '/variants/green/stone-tower-green.svg',
        '908a5d67-86db-40e3-a6e4-e55b205974f4'),
       ('72b173de-5f5b-40a2-bd4e-cd5a1ef0f2d5', 'Pride', '/variants/pride/mite-pride.svg',
        '00e6f81c-b06b-4390-a1a4-7062883e708b'),
       ('76893b69-43ed-4bc3-b678-9072b818c5bc', 'Grün', '/variants/green/mite-green.svg',
        '00e6f81c-b06b-4390-a1a4-7062883e708b'),
       ('778a8e4f-b5f6-4877-b50e-b351f52287b7', 'Grün', '/variants/green/dragon-head-green.svg',
        '8db73609-4a95-4b66-aaf0-6dbee2d24a68'),
       ('7cf314db-649e-40e9-8a06-df99b5a6a330', 'Grün', '/variants/green/bird-claw-green.svg',
        'eed808b8-2bd2-4cd9-8100-5f4df404b909'),
       ('846ff0a9-df56-48a4-84a5-d41d091b6f6a', 'Grün', '/variants/green/crowned-skull-green.svg',
        '5327dfe6-1dca-4ee4-801c-72e1c6a6eb99'),
       ('84a6e4b4-872d-4757-8c38-8693e0fc7c1b', 'Blau', '/variants/blue/stone-tower-blue.svg',
        '908a5d67-86db-40e3-a6e4-e55b205974f4'),
       ('888c459b-6a27-4b1e-bf4a-460072f8a2ba', 'Rot', '/variants/red/relic-blade-red.svg',
        '888c459b-6a27-4b1e-bf4a-460072f8a2ba'),
       ('8a4c34ba-bdbb-4e6f-b4be-23505123e5d7', 'Grün', '/variants/green/closed-barbute-green.svg',
        '5eb74ea0-8668-429e-981a-51f2d50d2fc0'),
       ('8db73609-4a95-4b66-aaf0-6dbee2d24a68', 'Rot', '/variants/red/dragon-head-red.svg',
        '8db73609-4a95-4b66-aaf0-6dbee2d24a68'),
       ('908a5d67-86db-40e3-a6e4-e55b205974f4', 'Rot', '/variants/red/stone-tower-red.svg',
        '908a5d67-86db-40e3-a6e4-e55b205974f4'),
       ('94cf9f68-7a5f-4f07-8bfc-e9d9f949f321', 'Pride', '/variants/pride/bison-pride.svg',
        '3d2289fb-042f-487c-a62d-989e0c08957f'),
       ('99c18d42-c0bc-4d07-9317-d3be23f17d78', 'Blau', '/variants/blue/angel-outfit-blue.svg',
        'e6320a62-ef27-4744-a6a3-62d4dbf826cb'),
       ('9b7c9a9c-01ad-41b0-9706-d593d228b6c4', 'Pride', '/variants/pride/wolf-head-pride.svg',
        '3b7d96d7-29ee-42b1-abb1-ad5b1a4da69f'),
       ('9d2c63ac-c39f-47c6-b66c-8bc383a68f25', 'Pride', '/variants/pride/checked-shield-pride.svg',
        'd89129a6-6325-40e7-b074-398455aeee75'),
       ('a5c8e27b-c0c1-43d1-ae16-7b0a0805c993', 'Blau', '/variants/blue/shark-jaws-blue.svg',
        '01a8ae40-0f45-48dd-9df2-496071f32095'),
       ('a6cd7db0-e5ed-4196-8a89-6fbc5f0cc89f', 'Pride', '/variants/pride/shark-jaws-pride.svg',
        '01a8ae40-0f45-48dd-9df2-496071f32095'),
       ('a8a80d12-df2d-466b-a4ac-019a76b14f84', 'Blau', '/variants/blue/checked-shield-blue.svg',
        'd89129a6-6325-40e7-b074-398455aeee75'),
       ('ad9b7f5d-c697-40e5-93d6-8a77d09b0b01', 'Grün', '/variants/green/small-fire-green.svg',
        'b0ed5200-fccf-48c5-b14b-64c28250b518'),
       ('b040e0c7-d678-4d6a-b105-fc144b5fa3b1', 'Blau', '/variants/blue/relic-blade-blue.svg',
        '888c459b-6a27-4b1e-bf4a-460072f8a2ba'),
       ('b097d29c-0103-4b9b-a70c-dfd073e7c2ed', 'Blau', '/variants/blue/heartburn-blue.svg',
        '44e5f640-50c7-42df-8d39-fee97ecbbf1f'),
       ('b0ed5200-fccf-48c5-b14b-64c28250b518', 'Rot', '/variants/red/small-fire-red.svg',
        'b0ed5200-fccf-48c5-b14b-64c28250b518'),
       ('b153ed71-e062-40d6-9dff-3096a586ad84', 'Pride', '/variants/pride/small-fire-pride.svg',
        'b0ed5200-fccf-48c5-b14b-64c28250b518'),
       ('b1b408fe-d5f3-4f5b-9490-6704362995a0', 'Blau', '/variants/blue/closed-barbute-blue.svg',
        '5eb74ea0-8668-429e-981a-51f2d50d2fc0'),
       ('b842d36f-b388-4372-b0f0-8c25d51718e1', 'Grün', '/variants/green/bison-green.svg',
        '3d2289fb-042f-487c-a62d-989e0c08957f'),
       ('b91f9415-43ca-4d56-bd57-27c7b0d5b2e9', 'Blau', '/variants/blue/tiger-head-blue.svg',
        '0e1dc401-29cd-4949-94bf-f9b8833bfb51'),
       ('bd79e9d7-28d1-4797-8a5b-7b2b5d5fdd12', 'Pride', '/variants/pride/tiger-head-pride.svg',
        '0e1dc401-29cd-4949-94bf-f9b8833bfb51'),
       ('c6b9c46c-b877-4f39-8e1d-fd19f3b2b763', 'Blau', '/variants/blue/curly-wing-blue.svg',
        '61d4ec76-77df-4458-b694-e47e79d123d3'),
       ('c7e5de39-bc61-4389-bb51-d34008d0069e', 'Pride', '/variants/pride/wyvern-pride.svg',
        '621316ea-a2d9-44c4-96fe-d9e80d0a7ba9'),
       ('cf302d1d-dedb-4793-9b1b-53522d70cc7b', 'Blau', '/variants/blue/bird-claw-blue.svg',
        'eed808b8-2bd2-4cd9-8100-5f4df404b909'),
       ('d5d03877-c379-4864-b8c0-8502ff745a59', 'Blau', '/variants/blue/crowned-skull-blue.svg',
        '5327dfe6-1dca-4ee4-801c-72e1c6a6eb99'),
       ('d762a100-e042-4bc0-9a02-b23e8bc5032a', 'Grün', '/variants/green/horse-head-green.svg',
        'e208994e-90f7-4328-99a3-34e95f91dbe8'),
       ('d89129a6-6325-40e7-b074-398455aeee75', 'Rot', '/variants/red/checked-shield-red.svg',
        'd89129a6-6325-40e7-b074-398455aeee75'),
       ('db1e7175-0795-463a-bc59-e1fc3754fa00', 'Grün', '/variants/green/heartburn-green.svg',
        '44e5f640-50c7-42df-8d39-fee97ecbbf1f'),
       ('dce4c8bc-9001-44f4-b5f7-f8f0c7a40053', 'Pride', '/variants/pride/angel-outfit-pride.svg',
        'e6320a62-ef27-4744-a6a3-62d4dbf826cb'),
       ('e208994e-90f7-4328-99a3-34e95f91dbe8', 'Rot', '/variants/red/horse-head-red.svg',
        'e208994e-90f7-4328-99a3-34e95f91dbe8'),
       ('e2b8e7ad-fc83-462d-8d8e-993ba14f3226', 'Grün', '/variants/green/checked-shield-green.svg',
        'd89129a6-6325-40e7-b074-398455aeee75'),
       ('e3cde42d-e5c3-41a9-9c5b-773cbcc5a8db', 'Pride', '/variants/pride/dragon-head-pride.svg',
        '8db73609-4a95-4b66-aaf0-6dbee2d24a68'),
       ('e6320a62-ef27-4744-a6a3-62d4dbf826cb', 'Rot', '/variants/red/angel-outfit-red.svg',
        'e6320a62-ef27-4744-a6a3-62d4dbf826cb'),
       ('ed404477-26e2-47c3-b4de-e80316a65f5b', 'Grün', '/variants/green/shark-jaws-green.svg',
        '01a8ae40-0f45-48dd-9df2-496071f32095'),
       ('eed808b8-2bd2-4cd9-8100-5f4df404b909', 'Rot', '/variants/red/bird-claw-red.svg',
        'eed808b8-2bd2-4cd9-8100-5f4df404b909'),
       ('f0f1e054-bb44-4b44-8ea4-0e20239d3176', 'Grün', '/variants/green/desert-skull-green.svg',
        '5d9e070b-28aa-4be9-b6a1-3b647a709124'),
       ('f39440d5-17bc-487b-9d9a-627edc698f0d', 'Blau', '/variants/blue/small-fire-blue.svg',
        'b0ed5200-fccf-48c5-b14b-64c28250b518'),
       ('f44e1be6-c12b-41a7-aef4-9bb9ebcd72f1', 'Blau', '/variants/blue/mite-blue.svg',
        '00e6f81c-b06b-4390-a1a4-7062883e708b'),
       ('f495bb99-7e71-44f4-b99a-bbcb0a73a559', 'Pride', '/variants/pride/curly-wing-pride.svg',
        '61d4ec76-77df-4458-b694-e47e79d123d3'),
       ('f681d1b0-d897-47fc-94be-b5cf80e0d059', 'Grün', '/variants/green/curly-wing-green.svg',
        '61d4ec76-77df-4458-b694-e47e79d123d3'),
       ('f6d1c8ac-0722-4f51-b2f9-d254cfb89427', 'Pride', '/variants/pride/relic-blade-pride.svg',
        '888c459b-6a27-4b1e-bf4a-460072f8a2ba'),
       ('f74bc4be-b618-49f1-a1c9-bb1db1db4d30', 'Pride', '/variants/pride/whirlwind-pride.svg',
        '1036a5f4-3a7c-410e-b46f-82300b867603'),
       ('fa9a0c11-84a7-4fcb-8041-cfc8e32d317f', 'Blau', '/variants/blue/wolf-head-blue.svg',
        '3b7d96d7-29ee-42b1-abb1-ad5b1a4da69f'),
       ('fd43d467-e7d5-4621-b8b0-4e8f4b42cfdb', 'Pride', '/variants/pride/desert-skull-pride.svg',
        '5d9e070b-28aa-4be9-b6a1-3b647a709124'),
       ('fe0a3e99-9357-46d1-b409-95168b7c028b', 'Blau', '/variants/blue/whirlwind-blue.svg',
        '1036a5f4-3a7c-410e-b46f-82300b867603');
