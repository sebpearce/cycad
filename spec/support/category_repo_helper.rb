module CategoryRepoHelper
  def find_category(id)
    Cycad::Repository.for(:category).by_id(id)
  end

  def all_categories
    Cycad::Repository.for(:category).all
  end
end
