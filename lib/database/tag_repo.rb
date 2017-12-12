require 'rom-repository'

module Database
  class TagRepo < ROM::Repository[:tags]
    commands :create, update: :by_pk, delete: :by_pk
  end
end
