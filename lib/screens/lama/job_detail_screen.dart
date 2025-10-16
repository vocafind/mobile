import 'package:flutter/material.dart';
import 'package:jobfair/api/api_service.dart';
import 'package:jobfair/models/loker_umum_detail_model.dart'; // pastikan model detail

class JobDetailScreen extends StatefulWidget {
  final String lowonganId;
  const JobDetailScreen({super.key, required this.lowonganId});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  LokerUmumDetail? lokerDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  void fetchDetail() async {
    final detail = await ApiService().getLokerUmumDetailById(widget.lowonganId);
    setState(() {
      lokerDetail = detail;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (lokerDetail == null) {
      return const Scaffold(
        body: Center(child: Text("Lowongan tidak ditemukan")),
      );
    }

    final loker = lokerDetail!;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 75,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 23,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 39,
                        height: 39,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Detail Lowongan",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "SF Pro",
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(loker),
                    _buildTags(loker),
                    const SizedBox(height: 20),
                    _buildExperienceEducation(loker),
                    const SizedBox(height: 20),
                    _buildJobDescription(loker),
                    const SizedBox(height: 20),
                    _buildQualifications(loker),
                    const SizedBox(height: 20),
                    _buildBenefits(loker),
                    const SizedBox(height: 20),
                    _buildAdditionalRequirements(loker),
                    const SizedBox(height: 20),
                    _buildFacilities(loker),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.fromLTRB(31, 0, 31, 26),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF2A3038).withOpacity(0.95),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur Lamar Pekerjaan akan segera hadir!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Center(
                child: Text(
                  "Lamar Sekarang",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "SF Pro",
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withOpacity(0.95),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(LokerUmumDetail loker) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(23, 30, 23, 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF0987BB),
              borderRadius: BorderRadius.circular(9),
            ),
          ),
          const SizedBox(width: 21),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loker.posisi,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  loker.companyName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  loker.lokasi ?? "-",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags(LokerUmumDetail loker) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(104, 0, 23, 20),
      child: Row(
        children: [
          _buildTag(loker.jenisPekerjaan),
          const SizedBox(width: 15),
          if (loker.opsiKerjaRemote) _buildTag("Remote"),
        ],
      ),
    );
  }

  Widget _buildExperienceEducation(LokerUmumDetail loker) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Container(
        height: 59,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "5-7 Thn",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Experience",
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            Container(width: 1, height: 40, color: const Color(0xFFE2E8F0)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    loker.minimalLulusan ?? "-",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Pendidikan",
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobDescription(LokerUmumDetail loker) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 31),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(19),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.description, size: 21, color: Color(0xFF0987BB)),
                SizedBox(width: 14),
                Text(
                  "Deskripsi Pekerjaan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 13),
            Text(
              loker.deskripsiPekerjaan,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 14,
                height: 1.36,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualifications(LokerUmumDetail loker) {
    if (loker.jobQualifications.isEmpty) return const SizedBox.shrink();
    return _buildSectionList(
      "Kualifikasi & Persyaratan",
      loker.jobQualifications.map((e) => e.kualifikasi).toList(),
    );
  }

  Widget _buildBenefits(LokerUmumDetail loker) {
    if (loker.jobBenefits.isEmpty) return const SizedBox.shrink();
    return _buildSectionList(
      "Benefit",
      loker.jobBenefits.map((e) => e.benefit).toList(),
    );
  }

  Widget _buildAdditionalRequirements(LokerUmumDetail loker) {
    if (loker.jobAdditionalRequirements.isEmpty) return const SizedBox.shrink();
    return _buildSectionList(
      "Persyaratan Tambahan",
      loker.jobAdditionalRequirements.map((e) => e.persyaratan).toList(),
    );
  }

  Widget _buildFacilities(LokerUmumDetail loker) {
    if (loker.jobAdditionalFacilities.isEmpty) return const SizedBox.shrink();
    return _buildSectionList(
      "Fasilitas",
      loker.jobAdditionalFacilities.map((e) => e.fasilitas).toList(),
    );
  }

  Widget _buildSectionList(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 31),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(19),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 19,
                  color: Color(0xFF0987BB),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map(
              (e) => Column(
                children: [_buildBulletPoint(e), const SizedBox(height: 18)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      height: 23,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 7,
          height: 7,
          margin: const EdgeInsets.only(top: 4),
          decoration: const BoxDecoration(
            color: Color(0xFF0987BB),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Color(0xFF64748B),
              height: 1.36,
            ),
          ),
        ),
      ],
    );
  }
}
