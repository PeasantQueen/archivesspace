require 'spec_helper'

describe ShelflistReport do
  let(:datab) { Sequel.connect(AppConfig[:db_url]) }
  let(:report) { ShelflistReport.new({:repo_id => 2},
                                {},
                                datab) }
  it 'returns the correct fields for the shelflist report' do
    expect(report.query.first.keys.length).to eq(18)
    puts "#{report.query.first.keys}"
    report.query.each do |res|
      puts "LANEY #{res.inspect}"
    end
    # expect(report.query.first).to have_key(:location_id)
    # expect(report.query.first).to have_key(:building)
    # expect(report.query.first).to have_key(:title)
    # expect(report.query.first).to have_key(:floor)
    # expect(report.query.first).to have_key(:room)
    # expect(report.query.first).to have_key(:area)
    # expect(report.query.first).to have_key(:location_barcode)
    # expect(report.query.first).to have_key(:location_coordinate)
  end
  it 'has the correct template name' do
      # expect(report.template).to eq('shelflist_report.erb')
  end
  it 'renders the expected report' do
    # puts "LANEY trying to render the report"
    # rend = ReportErbRenderer.new(report,{})
    # puts "LANEY #{rend.inspect}"
    # expect(rend.render(report.template)).to include('Shelflist Report')
  end
end
