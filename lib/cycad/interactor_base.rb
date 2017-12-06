module Cycad
  class InteractorBase
    # attr_reader :repo

    # def initialize(repo: repo)
    #   @repo = repo
    # end

    def self.repo
      Cycad.repo
    end
  end
end
