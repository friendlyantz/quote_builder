FactoryBot.define do
  factory :item do
    trait :duty5_trait do
      import_duty { 0.05 }
    end

    trait :tax10_trait do
      tax { 0.1 }
    end

    trait :book_trait do
      name { 'Book' }
      individual_cost { 0.5 }
    end

    trait :face_mask_trait do
      name { 'Face mask' }
      individual_cost { 1.0 }
    end

    trait :first_aid_kit_trait do
      name { 'First aid kit' }
      individual_cost { 10.0 }
    end

    trait :blue_ray_disk_trait do
      name { 'Blank Blue-Ray Disk' }
      individual_cost { 2.0 }
      tax { 0.02 }
    end

    factory :book, traits: %i[tax10_trait duty5_trait book_trait]
    factory :face_mask, traits: %i[duty5_trait face_mask_trait]
    factory :first_aid_kit, traits: [:first_aid_kit_trait]
    factory :blue_ray_disk, traits: [:blue_ray_disk_trait]
  end
end
