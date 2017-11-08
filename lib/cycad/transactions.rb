module Cycad
  class Transactions < Array
    def initialize(transactions)
      self.replace(transactions)
    end

    def date_range(start_date, end_date)
      filter(
        Cycad::Filters::DateFilter.filter_by_date_range(self, start_date, end_date)
      )
    end

    def income_only
      filter(
        Cycad::Filters::AmountFilter.filter_income_only(self)
      )
    end

    def expenses_only
      filter(
        Cycad::Filters::AmountFilter.filter_expenses_only(self)
      )
    end

    def amount_range(lower_limit, upper_limit)
      filter(
        Cycad::Filters::AmountFilter.filter_amount_range(self, lower_limit, upper_limit)
      )
    end

    def greater_than(lower_limit)
      filter(
        Cycad::Filters::AmountFilter.filter_greater_than(self, lower_limit)
      )
    end

    def less_than(upper_limit)
      filter(
        Cycad::Filters::AmountFilter.filter_less_than(self, upper_limit)
      )
    end

    def category(id)
      filter(
        Cycad::Filters::CategoryFilter.filter_by_category(self, id)
      )
    end

    private

    def filter(list)
      self.class.new(list)
    end
  end
end
