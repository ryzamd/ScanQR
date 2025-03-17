class OutBoundBusiness {
  static List<OutBoundRecord> getRecords(String selectedType) {
    if (selectedType == "SUBCONTRACTOR") {
      return [
        OutBoundRecord("SCaaaaaaaaaaaaa1", "9:00 AM", "01/01/2023", "50/100", "Pending"),
        OutBoundRecord("SC2", "9:30 AM", "01/01/2023", "100/100", "Completed"),
      ];
    } else if (selectedType == "WORK SHOP") {
      return [
        OutBoundRecord("WS1", "10:00 AM", "01/01/2023", "30/100", "Pending"),
        OutBoundRecord("WS2", "10:30 AM", "01/01/2023", "100/100", "Completed"),
      ];
    } else {
      return [];
    }
  }
}

class OutBoundRecord {
  final String id;
  final String time;
  final String date;
  final String quantity;
  final String status;

  OutBoundRecord(this.id, this.time, this.date, this.quantity, this.status);
}
