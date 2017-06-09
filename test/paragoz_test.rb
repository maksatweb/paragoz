require 'minitest/autorun'
require_relative "test_helper"

require_relative '../lib/paragoz.rb'

describe Paragoz do
  before do
    Paragoz::VERSION.wont_be_nil
    @doviz_biri = Paragoz.new_currency(code: Paragoz::CURRENCY_CODES.sample, amount: 0.50)
    @doviz_digeri = Paragoz.new_currency
  end
  
  describe 'Döviz biri nesnesi oluştuğunda' do
    it 'şu niteliklere sahiptir' do
      @doviz_biri.data.wont_be_nil
      @doviz_biri.base.must_be_kind_of String
      @doviz_biri.base.length.must_equal 3
      @doviz_biri.date.must_match /^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$/
      @doviz_biri.rates.wont_be_empty
      @doviz_biri.rates.must_be_kind_of Hash
      @doviz_biri.costs.wont_be_empty
      @doviz_biri.costs.must_be_kind_of Hash
      @doviz_biri.amount.must_be :>, 0
    end

    it 'take_rate davranışı her para kodu için float döner' do
      @doviz_biri.rates.each_key do |k|
        @doviz_biri.take_rate(k).must_be_kind_of Numeric
      end
    end

    it 'calculate_cost davranışı her dövizden o para sınıfı ile bir birim alma maliyetini döner' do
      Paragoz::CURRENCY_CODES.each do |i|
        @doviz_biri.calculate_cost(i).must_be_kind_of Numeric unless i == @doviz_biri.base
      end
    end

    it 'currency_to_currency bir döviz diğer döviz nesnesi cinsinden değerini hesaplar' do
      @doviz_biri.currency_to_currency(@doviz_digeri).must_be_kind_of Numeric
    end

    it 'exchange_to "parametre/nesnenin amount niteliği" kadar kodu belirtilen döviz olarak karşılığını döner' do
      Paragoz::CURRENCY_CODES.each do |i|
        @doviz_biri.exchance_to(i, rand(1..100)).must_be_kind_of Numeric unless i == @doviz_biri.base
      end
    end
  end

  describe 'Döviz diğeri (TRY) nesnesi oluştuğunda' do
    it 'şu niteliklere sahiptir' do
      @doviz_digeri.data.wont_be_nil
      @doviz_digeri.base.must_be_kind_of String
      @doviz_digeri.base.length.must_equal 3
      @doviz_digeri.date.must_match /^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$/
      @doviz_digeri.rates.wont_be_empty
      @doviz_digeri.rates.must_be_kind_of Hash
      @doviz_digeri.costs.wont_be_empty
      @doviz_digeri.costs.must_be_kind_of Hash
      @doviz_digeri.amount.must_be :>, 0
    end

    it 'take_rate davranışı her para kodu için float döner' do
      @doviz_digeri.rates.each_key do |k|
        @doviz_digeri.take_rate(k).must_be_kind_of Numeric
      end
    end

    it 'calculate_cost davranışı her dövizden o para sınıfı ile bir birim alma maliyetini döner' do
      Paragoz::CURRENCY_CODES.each do |i|
        @doviz_digeri.calculate_cost(i).must_be_kind_of Numeric unless i == @doviz_digeri.base
      end
    end

    it 'currency_to_currency bir döviz diğer döviz nesnesi cinsinden değerini hesaplar' do
      @doviz_digeri.currency_to_currency(@doviz_biri).must_be_kind_of Numeric
    end

    it 'exchange_to "parametre/nesnenin amount niteliği" kadar kodu belirtilen döviz olarak karşılığını döner' do
      Paragoz::CURRENCY_CODES.each do |i|
        @doviz_digeri.exchance_to(i, rand(1..100)).must_be_kind_of Numeric unless i == @doviz_digeri.base
      end
    end
  end
end
