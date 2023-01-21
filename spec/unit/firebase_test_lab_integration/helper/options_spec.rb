require_relative '../../../../lib/fastlane/plugin/firebase_test_lab_integration/helper/gcloud_helper'

describe FirebaseTestLabIntegration::Helper::Options do
  describe '#check_has_property' do
    property = 'property'
    it 'given no property' do
      expect { described_class.check_has_property({}, property) }.to raise_error(FastlaneCore::Interface::FastlaneError, "Each device must have #{property} property")
    end

    it 'given property' do
      expect { described_class.check_has_property({ property => property }, property) }.not_to raise_error(FastlaneCore::Interface::FastlaneError, "Each device must have #{property} property")
    end
  end
end
