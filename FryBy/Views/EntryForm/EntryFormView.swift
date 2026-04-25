import SwiftUI
import SwiftData

// MARK: - Form backing model

struct FryFormData {
    var restaurantName: String = ""
    var date: Date = .now
    var notes: String = ""
    var fryType: FryType = .shoestring
    var temperature: FryTemperature = .hot
    var hungerLevel: Int = 5
    var appearance: Int = 5
    var undippedFlavor: Int = 5
    var hasKetchupFlavor: Bool = false
    var ketchupFlavor: Int = 5
    var hasSignatureSauce: Bool = false
    var signatureSauceFlavor: Int = 5
    var signatureSauceName: String = ""
    var hasDunkability: Bool = false
    var dunkability: Int = 5
    var hasExtraSeasoning: Bool = false
    var extraSeasoning: Int = 5
    var extraSeasoningName: String = ""
    var starchiness: Int = 0
    var crispyFloppyRatio: Int = 0
    var hasCrispyQuality: Bool = false
    var crispyQuality: Int = 0
    var hasFloppyQuality: Bool = false
    var floppyQuality: Int = 0

    init() {}

    init(from entry: FryEntry) {
        restaurantName      = entry.restaurantName
        date                = entry.date
        notes               = entry.notes ?? ""
        fryType             = entry.fryType
        temperature         = entry.temperature
        hungerLevel         = entry.hungerLevel
        appearance          = entry.appearance
        undippedFlavor      = entry.undippedFlavor
        hasKetchupFlavor    = entry.ketchupFlavor != nil
        ketchupFlavor       = entry.ketchupFlavor ?? 5
        hasSignatureSauce   = entry.signatureSauceFlavor != nil
        signatureSauceFlavor = entry.signatureSauceFlavor ?? 5
        signatureSauceName  = entry.signatureSauceName ?? ""
        hasDunkability      = entry.dunkability != nil
        dunkability         = entry.dunkability ?? 5
        hasExtraSeasoning   = entry.extraSeasoning != nil
        extraSeasoning      = entry.extraSeasoning ?? 5
        extraSeasoningName  = entry.extraSeasoningName ?? ""
        starchiness         = entry.starchiness
        crispyFloppyRatio   = entry.crispyFloppyRatio
        hasCrispyQuality    = entry.crispyQuality != nil
        crispyQuality       = entry.crispyQuality ?? 0
        hasFloppyQuality    = entry.floppyQuality != nil
        floppyQuality       = entry.floppyQuality ?? 0
    }

    var ratingInput: FryRatingInput {
        FryRatingInput(
            undippedFlavor:       undippedFlavor,
            appearance:           appearance,
            hungerLevel:          hungerLevel,
            temperature:          temperature,
            starchiness:          starchiness,
            crispyFloppyRatio:    crispyFloppyRatio,
            ketchupFlavor:        hasKetchupFlavor    ? ketchupFlavor        : nil,
            signatureSauceFlavor: hasSignatureSauce   ? signatureSauceFlavor : nil,
            dunkability:          hasDunkability      ? dunkability          : nil,
            extraSeasoning:       hasExtraSeasoning   ? extraSeasoning       : nil,
            crispyQuality:        hasCrispyQuality    ? crispyQuality        : nil,
            floppyQuality:        hasFloppyQuality    ? floppyQuality        : nil
        )
    }
}

// MARK: - Form view

struct EntryFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    private let editingEntry: FryEntry?
    @State private var data: FryFormData

    init(entry: FryEntry? = nil) {
        editingEntry = entry
        _data = State(initialValue: entry.map { FryFormData(from: $0) } ?? FryFormData())
    }

    private var isValid: Bool {
        !data.restaurantName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                basicInfoSection
                flavorSection
                textureSection
                contextSection
                notesSection
            }
            .navigationTitle(editingEntry == nil ? "New Entry" : "Edit Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(!isValid)
                }
            }
        }
    }

    // MARK: - Sections

    private var basicInfoSection: some View {
        Section("Restaurant") {
            TextField("Restaurant Name", text: $data.restaurantName)
            DatePicker(
                "Date & Time",
                selection: $data.date,
                displayedComponents: [.date, .hourAndMinute]
            )
            Picker("Fry Type", selection: $data.fryType) {
                ForEach(FryType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
        }
    }

    private var flavorSection: some View {
        Section("Flavor") {
            RatingSlider(title: "Undipped Flavor", value: $data.undippedFlavor)

            Toggle("Dipped in Ketchup", isOn: $data.hasKetchupFlavor)
            if data.hasKetchupFlavor {
                RatingSlider(title: "Flavor in Ketchup", value: $data.ketchupFlavor)
            }

            Toggle("Dipped in Other Sauce", isOn: $data.hasSignatureSauce)
            if data.hasSignatureSauce {
                RatingSlider(
                    title: data.signatureSauceName.isEmpty ? "Flavor in Other Sauce" : "Flavor in \(data.signatureSauceName)",
                    value: $data.signatureSauceFlavor
                )
                TextField("Other Sauce Name", text: $data.signatureSauceName)
            }

            Toggle("Dunkability", isOn: $data.hasDunkability)
            if data.hasDunkability {
                RatingSlider(title: "Sauce Retention", value: $data.dunkability)
            }

            Toggle("Extra Seasoning Present", isOn: $data.hasExtraSeasoning)
            if data.hasExtraSeasoning {
                RatingSlider(title: "Flavor with Extra Seasoning", value: $data.extraSeasoning)
                TextField("Seasoning Name", text: $data.extraSeasoningName)
            }
        }
    }

    private var textureSection: some View {
        Section("Texture") {
            SpectrumSlider(
                title: "Starchiness",
                value: $data.starchiness,
                negativeLabel: "Not Starchy",
                positiveLabel: "Too Starchy"
            )

            RatioSlider(value: $data.crispyFloppyRatio)

            Toggle("Crispy Fry Quality", isOn: $data.hasCrispyQuality)
            if data.hasCrispyQuality {
                SpectrumSlider(
                    title: "",
                    value: $data.crispyQuality,
                    negativeLabel: "Not Crispy Enough",
                    positiveLabel: "Too Crispy"
                )
            }

            Toggle("Floppy Fry Quality", isOn: $data.hasFloppyQuality)
            if data.hasFloppyQuality {
                SpectrumSlider(
                    title: "",
                    value: $data.floppyQuality,
                    negativeLabel: "Not Floppy Enough",
                    positiveLabel: "Too Floppy"
                )
            }
        }
    }

    private var contextSection: some View {
        Section("Context") {
            Picker("Temperature", selection: $data.temperature) {
                ForEach(FryTemperature.allCases, id: \.self) { temp in
                    Text(temp.rawValue).tag(temp)
                }
            }
            RatingSlider(
                title: "Hunger Level",
                value: $data.hungerLevel,
                leftLabel: "Full",
                rightLabel: "Starving"
            )
            RatingSlider(
                title: "Appearance",
                value: $data.appearance,
                leftLabel: "Disgusting",
                rightLabel: "Incredible"
            )
        }
    }

    private var notesSection: some View {
        Section("Notes") {
            TextField("Optional notes...", text: $data.notes, axis: .vertical)
                .lineLimit(3...6)
        }
    }

    // MARK: - Save

    private func save() {
        let score = FryScorer.score(data.ratingInput)
        let trimmedName = data.restaurantName.trimmingCharacters(in: .whitespaces)
        let notesValue: String? = data.notes.isEmpty ? nil : data.notes
        let sauceName: String? = data.hasSignatureSauce && !data.signatureSauceName.isEmpty ? data.signatureSauceName : nil
        let seasoningName: String? = data.hasExtraSeasoning && !data.extraSeasoningName.isEmpty ? data.extraSeasoningName : nil

        if let entry = editingEntry {
            entry.restaurantName      = trimmedName
            entry.date                = data.date
            entry.notes               = notesValue
            entry.fryType             = data.fryType
            entry.temperature         = data.temperature
            entry.hungerLevel         = data.hungerLevel
            entry.appearance          = data.appearance
            entry.undippedFlavor      = data.undippedFlavor
            entry.ketchupFlavor       = data.hasKetchupFlavor  ? data.ketchupFlavor        : nil
            entry.signatureSauceFlavor = data.hasSignatureSauce ? data.signatureSauceFlavor : nil
            entry.signatureSauceName  = sauceName
            entry.dunkability         = data.hasDunkability     ? data.dunkability          : nil
            entry.extraSeasoning      = data.hasExtraSeasoning  ? data.extraSeasoning       : nil
            entry.extraSeasoningName  = seasoningName
            entry.starchiness         = data.starchiness
            entry.crispyFloppyRatio   = data.crispyFloppyRatio
            entry.crispyQuality       = data.hasCrispyQuality   ? data.crispyQuality        : nil
            entry.floppyQuality       = data.hasFloppyQuality   ? data.floppyQuality        : nil
            entry.overallScore        = score
        } else {
            let newEntry = FryEntry(
                restaurantName:       trimmedName,
                date:                 data.date,
                notes:                notesValue,
                fryType:              data.fryType,
                temperature:          data.temperature,
                hungerLevel:          data.hungerLevel,
                appearance:           data.appearance,
                undippedFlavor:       data.undippedFlavor,
                ketchupFlavor:        data.hasKetchupFlavor  ? data.ketchupFlavor        : nil,
                signatureSauceFlavor: data.hasSignatureSauce ? data.signatureSauceFlavor : nil,
                signatureSauceName:   sauceName,
                dunkability:          data.hasDunkability     ? data.dunkability          : nil,
                extraSeasoning:       data.hasExtraSeasoning  ? data.extraSeasoning       : nil,
                extraSeasoningName:   seasoningName,
                starchiness:          data.starchiness,
                crispyFloppyRatio:    data.crispyFloppyRatio,
                crispyQuality:        data.hasCrispyQuality   ? data.crispyQuality        : nil,
                floppyQuality:        data.hasFloppyQuality   ? data.floppyQuality        : nil,
                overallScore:         score
            )
            modelContext.insert(newEntry)
        }

        dismiss()
    }
}
