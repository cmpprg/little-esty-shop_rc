require 'rails_helper'

RSpec.describe 'As a merchant.', type: :feature do
  describe 'When I visit my dashboard.' do 
    it 'I can see my name displayed.' do
      merchant = create(:merchant)
      
      visit "/merchants/#{merchant.id}/dashboard" #merchant_dashboard_index_path
      
      within '#merchant-name' do
        expect(page).to have_content(merchant.name)
      end
    end
    
    it 'I can see and use a link to merchant items index' do
      merchant = create(:merchant)

      visit(merchant_dashboard_index_path(merchant))

      within '.dashboard-links' do
        click_link('My Items')
      end

      expect(current_path).to eq("/merchants/#{merchant.id}/items")
    end

    it 'I can see and use a link to merchant invoices index' do
      merchant = create(:merchant)

      visit(merchant_dashboard_index_path(merchant))

      within '.dashboard-links' do
        click_link('My Invoices')
      end

      expect(current_path).to eq("/merchants/#{merchant.id}/invoices")
    end

    it 'I see the names of my top 5 customers, who have the largest number of
        successful transactions for my items' do
      
      merchant = create(:merchant)
      customer_1 = create(:customer)
      customer_2 = create(:customer)
      customer_3 = create(:customer)
      customer_4 = create(:customer)
      customer_5 = create(:customer)
      customer_6 = create(:customer)
      customer_7 = create(:customer)

      # Create resources from transactions to merchants, switch customer 1 & 2
      # to ensure order is based on number of successful transactions and not
      # order in DB.
      7.times { create_all_resources_for(merchant, customer_2, 'success') } #create_all_resources_for method found in Helpers module ./spec/helpers
      6.times { create_all_resources_for(merchant, customer_1, 'success') }
      5.times { create_all_resources_for(merchant, customer_3, 'success') }
      4.times { create_all_resources_for(merchant, customer_4, 'success') }
      3.times { create_all_resources_for(merchant, customer_5, 'success') }
      2.times { create_all_resources_for(merchant, customer_6, 'success') }
      1.times { create_all_resources_for(merchant, customer_7, 'success') }
      # I want to ensure that no failed transactions are counted
      2.times do 
        create_all_resources_for(merchant, customer_1, 'failed')
        create_all_resources_for(merchant, customer_2, 'failed')
        create_all_resources_for(merchant, customer_3, 'failed')
        create_all_resources_for(merchant, customer_4, 'failed')
        create_all_resources_for(merchant, customer_5, 'failed')
      end
      
      visit(merchant_dashboard_index_path(merchant))

      within('#top-five-customers') do
        expect(page).to have_content('Top Five Customers')
        expect(page.all('.top-customer')[0]).to have_content("1. #{customer_2.full_name.titlecase} - 7 purchases")
        expect(page.all('.top-customer')[1]).to have_content("2. #{customer_1.full_name.titlecase} - 6 purchases")
        expect(page.all('.top-customer')[2]).to have_content("3. #{customer_3.full_name.titlecase} - 5 purchases")
        expect(page.all('.top-customer')[3]).to have_content("4. #{customer_4.full_name.titlecase} - 4 purchases")
        expect(page.all('.top-customer')[4]).to have_content("5. #{customer_5.full_name.titlecase} - 3 purchases")
      end
    end

    it "I can see a section for 'items ready to ship' with names of items that are ordered and not yet shipped." do
      merchant = create(:merchant)
      item_1 = create(:item, merchant: merchant)
      item_2 = create(:item, merchant: merchant)
      item_3 = create(:item, merchant: merchant)
      item_4 = create(:item, merchant: merchant)
      invoice_1 = create(:invoice)
      invoice_2 = create(:invoice)
      invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, status: 0)
      invoice_item_3 = create(:invoice_item, invoice: invoice_1, item: item_2, status: 2)
      invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_3, status: 1)
      invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_4, status: 1)

      visit(merchant_dashboard_index_path(merchant))

      expect(page).to have_content('Items Ready to Ship')

      within('#items-ready-to-ship') do
        expect(page).to have_content(item_1.name)
        expect(page).to have_content(item_3.name)
        expect(page).to have_content(item_4.name)
        expect(page).to have_no_content(item_2.name)
      end
    end

    xit "I can see and invoice id that is a link to that invoice next to every'ready to ship' item." do
      merchant = create(:merchant)
      item_1 = create(:item, merchant: merchant)
      item_2 = create(:item, merchant: merchant)
      item_3 = create(:item, merchant: merchant)
      item_4 = create(:item, merchant: merchant)
      invoice_1 = create(:invoice)
      invoice_2 = create(:invoice)
      invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, result: 0)
      invoice_item_3 = create(:invoice_item, invoice: invoice_1, item: item_2, result: 2)
      invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_3, result: 1)
      invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_4, result: 1)
    end
  end
end