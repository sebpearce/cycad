class Transactions
  attr_reader :all

  def initialize(transactions)
    @all = transactions
  end

  def date_range(start_date, end_date)
    @all = Cycad::Filters::DateFilter.filter_by_date_range(all, start_date, end_date)
    self
  end

  def income_only
    @all = Cycad::Filters::AmountFilter.filter_income_only(all)
    self
  end

  def expenses_only
    @all = Cycad::Filters::AmountFilter.filter_expenses_only(all)
    self
  end

  def amount_range(lower_limit, upper_limit)
    @all = Cycad::Filters::AmountFilter.filter_amount_range(all, lower_limit, upper_limit)
    self
  end

  def greater_than(lower_limit)
    @all = Cycad::Filters::AmountFilter.filter_greater_than(all, lower_limit)
    self
  end

  def less_than(upper_limit)
    @all = Cycad::Filters::AmountFilter.filter_less_than(all, upper_limit)
    self
  end

  def category(id)
    @all = Cycad::Filters::CategoryFilter.filter_by_category(all, id)
    self
  end
end
