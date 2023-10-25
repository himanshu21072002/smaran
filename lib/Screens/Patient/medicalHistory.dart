// import 'dart:html';

import 'dart:developer';
import 'dart:io';

// import 'package:alzheimersapporig/Utils/uiHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:url_launcher/url_launcher.dart';

class PatientMedicalHistoryPage extends StatefulWidget {
  final String patientUid;
  const PatientMedicalHistoryPage({Key? key, required this.patientUid})
      : super(key: key);

  @override
  State<PatientMedicalHistoryPage> createState() => _PatientMedicalHistoryPageState();
}

class _PatientMedicalHistoryPageState extends State<PatientMedicalHistoryPage> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  void pickFile() async {
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(type: FileType.custom,allowMultiple: false,allowCompression: true,allowedExtensions: ['pdf']);
    if (result != null) {
      log("result is not null");
      // final path = result.files.single.path!;
      // print(path);
      // UIhelper.showAlertDialogue(context, "File picked", pickedFile!.name);
      setState(() {
        pickedFile = result.files.first;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    log("in upload file");
    String path = 'files/${pickedFile!.name}';
    var file = File(pickedFile!.path!);
    var ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });
    log("putfile done");
    final snapshot = await uploadTask!.whenComplete(() {
      log("Uploaded");
    });
    final urlDownload = await snapshot.ref.getDownloadURL();
    log('Download Link:  $urlDownload');
    await FirebaseFirestore.instance
        .collection("history files")
        .doc(widget.patientUid)
        .collection("Uploaded files")
        .doc(pickedFile!.name)
        .set({"url": urlDownload,"Date and time":DateTime.now()});
    log("firebase updated");
    setState(() {
      log("set state");
      uploadTask = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical History"),
      ),
      body: SafeArea(
        child: Column(children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("history files")
                  .doc(widget.patientUid).collection("Uploaded files").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;
                    if (datasnapshot.docs.isNotEmpty) {


                      log(datasnapshot.docs.length.toString());
                      // return Text(userMap.toString());
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: datasnapshot.docs.length,
                        itemBuilder: (context,index){
                          Map<String, dynamic> userMap =
                          datasnapshot.docs[index].data() as Map<String, dynamic>;
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.04,
                                vertical: height * 0.015),
                            child: Material(
                              elevation: 5,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> View(url: userMap['url'],)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black38),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin:
                                        EdgeInsets.only(top: height * 0.01),
                                        height: height * 0.12,
                                        width: width * 0.35,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage('image/pdf.png'),
                                                fit: BoxFit.fill)),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      Text(
                                        "Report ${index+1}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );

                        },
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),);
                    } else {
                      return const Text("No results found");
                    }
                  } else if (snapshot.hasError) {
                    return const Text("An error occured");
                  } else {
                    return const Text("No results found");
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              }),
          Expanded(child: Container()),
          (uploadTask!=null)?StreamBuilder<TaskSnapshot>(
            stream: uploadTask?.snapshotEvents,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                double progress = data.bytesTransferred / data.totalBytes;
                return SizedBox(
                  height: 50,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey,
                        color: Colors.green,
                      ),
                      Center(
                        child: Text(
                          "${(100 * progress).roundToDouble()}%",
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return const SizedBox(
                  height: 50,
                );
              }
            },
          ):Container(),
        ]),
      ),

    );
  }
}
class View extends StatelessWidget{
  PdfViewerController? _pdfViewerController;
  final url;
  View({super.key, this.url});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF View"),
      ),
      body: SfPdfViewer.network(
        url,
        controller: _pdfViewerController,
      ),
    );
  }
}