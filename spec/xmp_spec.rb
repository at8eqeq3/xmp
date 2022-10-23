# encoding: UTF-8
require './spec/spec_helper.rb'

describe XMP do
  describe "with xmp.xml" do
    before { @xmp = XMP.new(File.read('spec/fixtures/xmp.xml')) }

    it "should return all namespace names" do
      #@xmp.namespaces.should =~ %w{rdf x tiff exif xap aux Iptc4xmpCore photoshop crs dc}
      expect(@xmp.namespaces).to match_array(%w{rdf x tiff exif xap aux Iptc4xmpCore photoshop crs dc})
    end

    it "should return standalone attribute" do
      expect(@xmp.dc.title).to eq(['Tytuł zdjęcia'])
      expect(@xmp.dc.subject).to eq(['Słowa kluczowe i numery startowe.'])
      expect(@xmp.photoshop.SupplementalCategories).to eq(['Nazwa imprezy'])
    end

    it "should return embedded attribute" do
      expect(@xmp.Iptc4xmpCore.Location).to eq('Miejsce')
      expect(@xmp.photoshop.Category).to eq('Kategoria')
    end

    it "should raise NoMethodError on unknown attribute" do
      expect { @xmp.photoshop.UnknownAttribute }.to raise_error(NoMethodError)
    end

    describe "namespace 'tiff'" do
      before { @namespace = @xmp.tiff }

      it "should return all attribute names" do
        expect(@namespace.attributes).to match_array(%w{Make Model ImageWidth ImageLength XResolution YResolution ResolutionUnit})
      end
    end

    describe "namespace 'photoshop'" do
      before { @namespace = @xmp.photoshop }

      it "should return all attribute names" do
        expect(@namespace.attributes).to match_array(%w{LegacyIPTCDigest Category SupplementalCategories})
      end
    end
  end

  describe "with xmp2.xml" do
    before { @xmp = XMP.new(File.read('spec/fixtures/xmp2.xml')) }

    it "should return all namespace names" do
      expect(@xmp.namespaces).to match_array(%w{dc iX pdf photoshop rdf tiff x xap xapRights})
    end

    it "should return standalone attribute" do
      expect(@xmp.dc.creator).to eq(['BenjaminStorrier'])
      expect(@xmp.dc.subject).to eq(['SAMPLEkeyworddataFromIview'])
    end

    it "should return embedded attribute" do
      expect(@xmp.photoshop.Headline).to eq('DeniseTestImage')
      expect(@xmp.photoshop.Credit).to eq('Remco')
    end
  end
end
