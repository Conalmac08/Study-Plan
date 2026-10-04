/*
  LC Study Plan – Google Classroom → your app, automatically.
  Runs inside YOUR Google account (Apps Script), reads your Classroom
  (read-only) once an hour and sends the posts to your own Supabase row.
  Easiest: in the app, Settings → Google Classroom → "Copy script" gives you
  this file with the three values below already filled in.
  Setup steps: CLASSROOM_AUTO_SETUP.md
*/
var SUPABASE_URL = 'PASTE_PROJECT_URL';
var SUPABASE_KEY = 'PASTE_PUBLISHABLE_KEY';
var SYNC_ID      = 'PASTE_SYNC_ID';

// Run this once (▶ Run with "setup" selected). It syncs now and then every hour.
function setup() {
  ScriptApp.getProjectTriggers().forEach(function (t) {
    if (t.getHandlerFunction() === 'syncClassroom') ScriptApp.deleteTrigger(t);
  });
  ScriptApp.newTrigger('syncClassroom').timeBased().everyHours(1).create();
  syncClassroom();
}

function syncClassroom() {
  var items = [];
  var courses = Classroom.Courses.list({ studentId: 'me', courseStates: ['ACTIVE'], pageSize: 50 }).courses || [];
  courses.forEach(function (c) {
    var base = { course: c.name + (c.section ? ' ' + c.section : '') };
    var handed = {};
    try {
      (Classroom.Courses.CourseWork.StudentSubmissions.list(c.id, '-', { userId: 'me', pageSize: 100 }).studentSubmissions || [])
        .forEach(function (s) { if (s.state === 'TURNED_IN' || s.state === 'RETURNED') handed[s.courseWorkId] = true; });
    } catch (e) {}
    try {
      (Classroom.Courses.CourseWork.list(c.id, { pageSize: 20, orderBy: 'updateTime desc' }).courseWork || []).forEach(function (w) {
        var d = w.dueDate;
        items.push(mk(base, { id: 'w:' + w.id, wid: w.id, kind: 'work', title: w.title || 'Assignment', text: w.description || '',
          at: w.updateTime || w.creationTime, link: w.alternateLink, done: !!handed[w.id],
          due: d ? d.year + '-' + pad(d.month) + '-' + pad(d.day) : '' }));
      });
    } catch (e) {}
    try {
      (Classroom.Courses.Announcements.list(c.id, { pageSize: 15 }).announcements || []).forEach(function (a) {
        items.push(mk(base, { id: 'a:' + a.id, kind: 'ann', title: (a.text || '').split('\n')[0].slice(0, 120) || 'Announcement',
          text: a.text || '', at: a.updateTime || a.creationTime, link: a.alternateLink }));
      });
    } catch (e) {}
    try {
      (Classroom.Courses.CourseWorkMaterials.list(c.id, { pageSize: 10 }).courseWorkMaterial || []).forEach(function (m) {
        items.push(mk(base, { id: 'm:' + m.id, kind: 'mat', title: m.title || 'Material', text: m.description || '',
          at: m.updateTime || m.creationTime, link: m.alternateLink }));
      });
    } catch (e) {}
  });
  items.sort(function (a, b) { return String(b.at).localeCompare(String(a.at)); });
  var payload = { p_sync_id: SYNC_ID, p_data: { at: Date.now(), items: items.slice(0, 80), source: 'apps-script' } };
  var headers = { apikey: SUPABASE_KEY };
  if (SUPABASE_KEY.indexOf('eyJ') === 0) headers.Authorization = 'Bearer ' + SUPABASE_KEY;   // legacy anon key
  var res = UrlFetchApp.fetch(SUPABASE_URL.replace(/\/+$/, '') + '/rest/v1/rpc/feed_push', {
    method: 'post', contentType: 'application/json', headers: headers, payload: JSON.stringify(payload), muteHttpExceptions: true });
  if (res.getResponseCode() >= 300) throw new Error('Supabase said ' + res.getResponseCode() + ': ' + res.getContentText());
  Logger.log('Sent ' + items.length + ' Classroom posts from ' + courses.length + ' classes.');
}

function mk(base, o) { o.course = base.course; o.text = String(o.text || '').slice(0, 1500); return o; }
function pad(n) { return (n < 10 ? '0' : '') + n; }
