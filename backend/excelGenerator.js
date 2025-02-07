const ExcelJS = require('exceljs');

async function generateExcel(schedule, filePath) {
  const workbook = new ExcelJS.Workbook();
  const worksheet = workbook.addWorksheet('Schedule');

  worksheet.columns = [
    { header: 'Event Name', key: 'event_name', width: 30 },
    { header: 'Date', key: 'schedule_date', width: 15 },
    { header: 'Start Time', key: 'start_time', width: 15 },
    { header: 'End Time', key: 'end_time', width: 15 }
  ];

  schedule.forEach(event => {
    worksheet.addRow({
      event_name: event.event_name,
      schedule_date: event.schedule_date,
      start_time: event.start_time,
      end_time: event.end_time
    });
  });

  await workbook.xlsx.writeFile(filePath);
}

module.exports = { generateExcel };