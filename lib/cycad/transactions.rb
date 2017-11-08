module Cycad
  class Transactions < Array
    def initialize(transactions)
      self.replace(transactions)
    end

    def date_range(start_date, end_date)
      filter(
        Cycad::Filters::DateFilter::DateRange.filter(self, start_date, end_date)
      )
    end

    def income_only
      filter(
        Cycad::Filters::AmountFilter::IncomeOnly.filter(self)
      )
    end

    def expenses_only
      filter(
        Cycad::Filters::AmountFilter::ExpensesOnly.filter(self)
      )
    end

    def amount_range(lower_limit, upper_limit)
      filter(
        Cycad::Filters::AmountFilter::AmountRange.filter(self, lower_limit, upper_limit)
      )
    end

    def greater_than(lower_limit)
      filter(
        Cycad::Filters::AmountFilter::GreaterThan.filter(self, lower_limit)
      )
    end

    def less_than(upper_limit)
      filter(
        Cycad::Filters::AmountFilter::LessThan.filter(self, upper_limit)
      )
    end

    def category(id)
      filter(
        Cycad::Filters::CategoryFilter.filter(self, id)
      )
    end

    private

    def filter(list)
      self.class.new(list)
    end
  end
end
