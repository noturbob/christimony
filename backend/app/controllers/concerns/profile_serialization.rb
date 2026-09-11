module ProfileSerialization
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers
  end

  # Full profile payload used by index/feed/show/create/update. Carries
  # both `denomination_id` (writable) and `denomination` (display name)
  # so a client can round-trip an edit form without a separate lookup.
  def profile_json(profile)
    {
      id: profile.id,
      name: profile.name,
      profile_type: profile.profile_type,
      dob: profile.dob,
      age: profile.age,
      gender: profile.gender,
      city: profile.city,
      education: profile.education,
      profession: profile.profession,
      bio: profile.bio,
      status: profile.status,
      denomination_id: profile.denomination_id,
      denomination: profile.denomination&.name,
      photos: profile.profile_photos.map { |p| photo_json(p) },
      prompts: profile.profile_prompts.map { |pr| prompt_json(pr) }
    }
  end

  def photo_json(photo)
    {
      id: photo.id,
      url: photo_url(photo),
      thumb_url: photo_thumb_url(photo) || photo_url(photo),
      position: photo.position
    }
  end

  def prompt_json(prompt)
    {
      id: prompt.id,
      profile_id: prompt.profile_id,
      question: prompt.question,
      answer: prompt.answer
    }
  end

  # A lighter shape for embedding one profile inside another resource
  # (matches, introductions, conversations) -- always the same fields so
  # clients don't have to special-case each endpoint.
  def profile_summary(profile)
    return nil unless profile

    {
      id: profile.id,
      name: profile.name,
      city: profile.city,
      profile_type: profile.profile_type,
      age: profile.age,
      cover_photo_url: profile.profile_photos.first&.then { |p| photo_thumb_url(p) || photo_url(p) }
    }
  end

  private

  def photo_url(photo)
    return photo.url unless photo.image.attached?

    rails_blob_url(photo.image, host: request.base_url)
  rescue StandardError
    photo.url
  end

  def photo_thumb_url(photo)
    return nil unless photo.image.attached?

    variant = photo.image.variant(resize_to_limit: [ 600, 750 ]).processed
    rails_representation_url(variant, host: request.base_url)
  rescue StandardError
    nil
  end
end
