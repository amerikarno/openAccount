
class VerifyEmail {
  const VerifyEmail({
    required this.registeredEmail,
    required this.registeredPage,
  });

  final bool registeredEmail;
  final String registeredPage;
}

const homeNumberSubject = 'เลขที่';
const villageNoSubject = 'หมู่ที่';
const villageNameSubject = 'หมู่บ้าน';
const subStreetSubject = 'ซอย';
const streetSubject = 'ถนน';
const tambonSubject = 'แขวงตำบล';
const amphureSubject = 'เขตอำเภอ';
const provinceSubject = 'จังหวัด';
const zipcodeSubject = 'รหัสไปรษณีย์';
const countrySubject = 'ประเทศ';
const sourceOfIncomeSubject = 'แหล่งที่มาของรายได้';
const currentOccupationSubject = 'อาชีพปัจจุบัน';
const officeNameSubject = 'ชื่อสถานที่ทำงาน';
const typeOfBusinessSubject = 'ประเภทธุรกิจ';
const positionSubject = 'ตำแหน่งงาน';
const salarySubject = 'รายได้ต่อเดือน';
const otherAddressSubject = 'ที่อยู่อื่น (โปรดระบุ)';
const registeredAddressSubject = 'ที่อยู่ตามบัตรประชาชน';
const currentAddressSubject = 'ที่อยู่ปัจจุบัน';
const bankAccountNumberSubject = 'เลขที่บัญชี';
const bankNameSubject = 'ธนาคาร';
const bankBranchNameSubject = 'ชื่อสาขา';
const markImportant = '*';
const bankHeaderSubject = 'บัญชีธนาคารของท่าน (เพื่อความสะดวกในการถอนเงินและรับเงินปันผล)';
const firstBankSubject = 'กรุณาระบุชื่อธนาคารก่อนกรอกชื่อสาขา';
const secondBankSubject = 'เพิ่มบัญชีธนาคารที่ 2 (เพื่อใช้ฝากเงิน)';
const officeLocation = 'ที่ตั้งที่ทำงาน';
const pleaseSelectedYourRiskLevel = 'เลือกระดับความเสี่ยงประเภทนักลงทุน';
const studyOrEditSuitableLevel = 'ศึกษาหรือแก้ไขรายละเอียดแบบประเมิน';
const suitableDialogTitle = 'กรุณาเลือกข้อที่ตรงกับท่านมากที่สุดเพื่อท่านจะได้ทราบว่าท่านเหมาะที่จะลงทุนในทรัพย์สินประเภทใด';

final allfilter = RegExp(r'[a-zA-Z0-9ก-๛]');
final thaiEngFilter = RegExp(r'[a-zA-Zก-๛]');
final numberfilter = RegExp(r'[0-9]');
final thaifilter = RegExp(r'[ก-๛]');
final englishfilter = RegExp(r'[a-zA-Z]');
