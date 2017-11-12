names = ['産業技術大学院大学']
name_ens = ['AIIT']
descriptions = []
email_domains = ['aiit.ac.jp']

1.upto(names.length) do |n|
  University.create!(
    name: names[n - 1],
    name_en: name_ens[n - 1],
    description: descriptions[n - 1],
    email_domain: email_domains[n - 1]
  )
end