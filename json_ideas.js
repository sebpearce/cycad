CRUD


// create transaction route
{
  date: '',
  amount: 12,
  category_id: 12,
  tags: [
    '',
    ''
  ],
  notes: ''
}


// read transaction route
{
  amount: {
    lt: 50,
    gt: 30
    // eq: 10
  }
}

{
  amount : {
    lt: 50
  },
  date : {
    since: '2017-01-01',
    until: '2017-08-08'
  },
  category_id: [
    12, 94
  ]
}

// update (different endpoint for categories and transactions)
{
  id: 192,
  data: {
    amount: 17,
    date: '2018-02-14'
  }
}
