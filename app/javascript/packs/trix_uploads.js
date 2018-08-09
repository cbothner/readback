import { DirectUpload } from 'activestorage'

Trix.config.attachments.preview.caption = {
  name: false,
  size: false,
}

const uploadAttachment = attachment => {
  const file = attachment.file

  // your form needs the file_field direct_upload: true, which
  //  provides data-direct-upload-url
  // const url = input.dataset.directUploadUrl
  let upload = new DirectUpload(file, '/rails/active_storage/direct_uploads')

  upload.create((error, blob) => {
    if (error) {
      // Handle the error
      window.alert('Error uploading file from Trix')
    } else {
      // Add an appropriately-named hidden input to the form with a
      //  value of blob.signed_id so that the blob ids will be
      //  transmitted in the normal upload flow
      const hiddenField = document.createElement('input')
      hiddenField.setAttribute('type', 'hidden')
      hiddenField.name = 'dj[images][]'
      hiddenField.setAttribute('value', blob.signed_id)
      document.querySelector('form').appendChild(hiddenField)

      console.log(file)
      console.log(blob)
      console.log(blob.signed_id)

      return attachment.setAttributes({
        url: '/rails/active_storage/disk/' + blob.signed_id + '/' + file.name,
        href: '/rails/active_storage/disk/' + blob.signed_id + '/' + file.name,
      })
    }
  })
}

// const uploadAttachment = attachment => {
//   const file = attachment.file;
//
//   // your form needs the file_field direct_upload: true, which
//   //  provides data-direct-upload-url
//   let upload = new DirectUpload(file, '/rails/active_storage/direct_uploads')
//
//   upload.create((error, blob) => {
//     if (error) {
//       // Handle the error
//       window.alert('Error uploading file from Trix')
//     }
//     else {
//       let form = new FormData;
//       // form.append("key", key);
//       form.append("Content-Type", file.type);
//       // form.append("file", file);
//
//       // Add an appropriately-named hidden input to the form with a
//       //  value of blob.signed_id so that the blob ids will be
//       //  transmitted in the normal upload flow
//       const hiddenField = document.createElement('input')
//       hiddenField.setAttribute('type', 'hidden')
//       hiddenField.name = 'dj[images][]'
//       hiddenField.setAttribute('value', blob.signed_id)
//       form.appendChild(hiddenField)
//
//       let xhr = new XMLHttpRequest;
//       xhr.open("POST", host, true);
//       xhr.upload.onprogress = (event) => {
//         var progress;
//         progress = event.loaded / event.total * 100
//         return attachment.setUploadProgress(progress)
//       }
//       xhr.onload = () => {
//         var href, url;
//         if (xhr.status === 204) {
//           url = href = host + key;
//           return attachment.setAttributes({
//             url: url,
//             href: href
//           })
//         }
//       }
//       return xhr.send(form);
//
//     }
//   })
// }
//
//
//   let key = createStorageKey(file);
//   form = new FormData;
//   form.append("key", key);
//   form.append("Content-Type", file.type);
//   form.append("file", file);
//   xhr = new XMLHttpRequest;
//   xhr.open("POST", host, true);
//   xhr.upload.onprogress = function(event) {
//     var progress;
//     progress = event.loaded / event.total * 100;
//     return attachment.setUploadProgress(progress);
//   };
//   xhr.onload = function() {
//     var href, url;
//     if (xhr.status === 204) {
//       url = href = host + key;
//       return attachment.setAttributes({
//         url: url,
//         href: href
//       });
//     }
//   };
//   return xhr.send(form);
// };

// const uploadAttachment = (attachment) => {
//   const file = attachment.file;
//   let form, xhr;
//
//   let key = createStorageKey(file);
//   form = new FormData;
//   form.append("key", key);
//   form.append("Content-Type", file.type);
//   form.append("file", file);
//   xhr = new XMLHttpRequest;
//   xhr.open("POST", host, true);
//   xhr.upload.onprogress = function(event) {
//     var progress;
//     progress = event.loaded / event.total * 100;
//     return attachment.setUploadProgress(progress);
//   };
//   xhr.onload = function() {
//     var href, url;
//     if (xhr.status === 204) {
//       url = href = host + key;
//       return attachment.setAttributes({
//         url: url,
//         href: href
//       });
//     }
//   };
//   return xhr.send(form);
// };

// Listen for the Trix attachment event to trigger upload
addEventListener('trix-attachment-add', event => {
  const attachment = event.attachment
  if (attachment.file) {
    return uploadAttachment(attachment)
  }
})
