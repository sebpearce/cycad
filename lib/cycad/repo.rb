module Cycad
  class Repo
    # def_delegator :update, to: :database

    def initialize(database)
      @database = database
    end
  end
end
